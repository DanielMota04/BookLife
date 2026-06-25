import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:book_life/core/widgets/app_scaffold.dart';
import 'package:book_life/features/community/viewmodels/comunidade_viewmodel.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_auth/firebase_auth.dart';

class ComunidadePage extends StatefulWidget {
  const ComunidadePage({super.key});

  @override
  State<ComunidadePage> createState() => _ComunidadePageState();
}

class _ComunidadePageState extends State<ComunidadePage> {
  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ComunidadeViewModel>();

    return CustomScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Comunidade",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: viewModel.feedStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "O feed está vazio.\nComece a ler e compartilhar!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return _buildPostCard(context, docs[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final userName = data['userName'] ?? 'Usuário';
    final action = data['action'] ?? 'interagiu com';
    final bookTitle = data['bookTitle'] ?? 'um livro';
    final review = data['review'] ?? '';
    final rating = (data['rating'] ?? 0) as int;
    final isSpoiler = (data['isSpoiler'] ?? false) as bool;
    final likes = List<String>.from(data['likes'] ?? []);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isLiked = currentUserId != null && likes.contains(currentUserId);
    
    String timeAgo = '';
    if (data['timestamp'] != null) {
      final timestamp = data['timestamp'] as Timestamp;
      timeAgo = timeago.format(timestamp.toDate(), locale: 'pt_BR');
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(Icons.person, color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
                          children: [
                            TextSpan(text: '$userName ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: '$action '),
                            TextSpan(text: '$bookTitle', style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (rating > 0)
              Row(
                children: [
                  ...List.generate(
                    10,
                    (i) {
                      if (rating >= i + 1) {
                        return const Icon(Icons.star, color: Colors.amber, size: 16);
                      } else {
                        return const Icon(Icons.star_border, color: Colors.amber, size: 16);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "($rating/10)",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            if (review.isNotEmpty) ...[
              const SizedBox(height: 8),
              if (isSpoiler)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "⚠️ ALERTA DE SPOILER",
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                review,
                style: const TextStyle(fontSize: 14),
              ),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () {
                    if (currentUserId == null) return;
                    if (isLiked) {
                      FirebaseFirestore.instance.collection('feed').doc(doc.id).update({
                        'likes': FieldValue.arrayRemove([currentUserId])
                      });
                    } else {
                      FirebaseFirestore.instance.collection('feed').doc(doc.id).update({
                        'likes': FieldValue.arrayUnion([currentUserId])
                      });
                    }
                  },
                  icon: Icon(
                    isLiked ? Icons.thumb_up : Icons.thumb_up_outlined, 
                    size: 18,
                    color: isLiked ? Theme.of(context).colorScheme.primary : null,
                  ),
                  label: Text(likes.isEmpty ? "Curtir" : "${likes.length} Curtidas"),
                ),
                TextButton.icon(
                  onPressed: () => _showCommentsModal(context, doc.id),
                  icon: const Icon(Icons.comment_outlined, size: 18),
                  label: const Text("Comentar"),
                ),
                if (data['userId'] == FirebaseAuth.instance.currentUser?.uid) ...[
                  TextButton.icon(
                    onPressed: () async {
                      final TextEditingController editController = TextEditingController(text: review);
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Editar Resenha'),
                          content: TextField(
                            controller: editController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText: 'Edite sua resenha...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Salvar'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await FirebaseFirestore.instance.collection('feed').doc(doc.id).update({
                          'review': editController.text.trim(),
                        });
                        // Opcional: Atualizar na coleção de livros se tivéssemos o bookId salvo aqui.
                        // Como a busca por título pode ser imprecisa, a edição fica apenas no feed por enquanto.
                      }
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text("Editar"),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      bool confirm = await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Excluir Post'),
                          content: const Text('Tem certeza que deseja apagar esta publicação do feed?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Apagar', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      ) ?? false;
                      if (confirm) {
                        FirebaseFirestore.instance.collection('feed').doc(doc.id).delete();
                      }
                    },
                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    label: const Text("Excluir", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentsModal(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => _CommentsSheet(postId: postId),
    );
  }
}

class _CommentsSheet extends StatefulWidget {
  final String postId;
  const _CommentsSheet({required this.postId});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String userName = user.displayName ?? '';
    if (userName.isEmpty) userName = user.email?.split('@')[0] ?? 'Leitor';

    await FirebaseFirestore.instance
        .collection('feed')
        .doc(widget.postId)
        .collection('comments')
        .add({
      'userId': user.uid,
      'userName': userName,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text("Comentários", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('feed')
                    .doc(widget.postId)
                    .collection('comments')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("Nenhum comentário ainda. Seja o primeiro!"));
                  }

                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final userName = data['userName'] ?? 'Usuário';
                      final text = data['text'] ?? '';
                      return ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person, size: 20),
                          radius: 16,
                        ),
                        title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Text(text, style: const TextStyle(fontSize: 14)),
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Escreva um comentário...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendComment,
                  icon: const Icon(Icons.send, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
