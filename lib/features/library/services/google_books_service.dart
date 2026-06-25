import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:book_life/core/models/book_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleBooksService {
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  Future<Book?> buscarLivroPorIsbn(String isbn) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?q=isbn:$isbn'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['totalItems'] != null && data['totalItems'] > 0) {
          final item = data['items'][0];
          final volumeInfo = item['volumeInfo'];
          
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) return null;

          final title = volumeInfo['title'] ?? 'Título Desconhecido';
          final authorsList = volumeInfo['authors'] as List<dynamic>?;
          final author = (authorsList != null && authorsList.isNotEmpty) ? authorsList.first.toString() : 'Autor Desconhecido';
          final publisher = volumeInfo['publisher'];
          final pageCount = volumeInfo['pageCount'] ?? 0;
          final categories = volumeInfo['categories'] as List<dynamic>?;
          final genres = categories?.map((e) => e.toString()).toList() ?? [];
          final description = volumeInfo['description'];
          
          final imageLinks = volumeInfo['imageLinks'];
          final coverUrl = imageLinks != null ? (imageLinks['thumbnail'] ?? imageLinks['smallThumbnail']) : null;

          // Substituir http por https no coverUrl para evitar bloqueios de segurança
          final safeCoverUrl = coverUrl?.replaceAll('http://', 'https://');

          return Book(
            id: DateTime.now().millisecondsSinceEpoch.toString(), // ID temporário
            userId: user.uid,
            title: title,
            author: author,
            isbn: isbn,
            publisher: publisher,
            totalPages: pageCount,
            currentPage: 0,
            genres: genres,
            synopsis: description,
            coverUrl: safeCoverUrl,
            addedAt: DateTime.now(),
          );
        }
      }
      return null;
    } catch (e) {
      print('Erro ao buscar livro na API: $e');
      return null;
    }
  }
}
