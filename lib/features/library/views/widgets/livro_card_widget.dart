import 'package:book_life/core/enums/reading_status.dart';
import 'package:book_life/core/models/book_model.dart';
import 'package:flutter/material.dart';

class LivroCard extends StatelessWidget {
  final Book livro;
  const LivroCard({super.key, required this.livro});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            child: livro.coverBytes != null
                ? Image.memory(
                    livro.coverBytes!,
                    width: 90,
                    height: 130,
                    fit: BoxFit.cover,
                  )
                : livro.coverUrl != null
                ? Image.network(
                    livro.coverUrl!,
                    width: 90,
                    height: 130,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 90,
                    height: 130,
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.book,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    livro.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text("de ${livro.author}", style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 18),
                  Text(
                    "Progresso: ${livro.displayProgressPercentage}%",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: livro.progressPercentage,
                    minHeight: 5,
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            livro.rating?.toStringAsFixed(0) ?? '0',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        livro.status.displayName,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
