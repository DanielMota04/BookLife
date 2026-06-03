import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:translator/translator.dart';
import 'package:book_life/core/models/book_model.dart';

class BookRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleTranslator _tradutor = GoogleTranslator();

  // Salva o objeto Book no Firestore
  Future<void> salvarLivroNoBanco(Book livro) async {
    await _firestore.collection('books').add(livro.toMap());
  }

  // Busca na API do Hardcover, com isso, traduz e retorna um Map com os dados
  Future<Map<String, dynamic>?> buscarDadosLivro(String isbnLimpo) async {
    List<String> variacoesDoIsbn = _gerarVariacoesDoIsbn(isbnLimpo);
    final arrayDeIsbnsFormatado = jsonEncode(variacoesDoIsbn);

    const tokenAutenticacao =
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJIYXJkY292ZXIiLCJ2ZXJzaW9uIjoiOCIsImp0aSI6IjJlMTcxMzM1LTIxOGEtNDAwMy05ZjgzLTY4YzFiYWU1ODRlYSIsImFwcGxpY2F0aW9uSWQiOjIsInN1YiI6Ijk5Njk5IiwiYXVkIjoiMSIsImlkIjoiOTk2OTkiLCJsb2dnZWRJbiI6dHJ1ZSwiaWF0IjoxNzc4ODg0MjQ2LCJleHAiOjE4MTA0MjAyNDYsImh0dHBzOi8vaGFzdXJhLmlvL2p3dC9jbGFpbXMiOnsieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ1c2VyIl0sIngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6InVzZXIiLCJ4LWhhc3VyYS1yb2xlIjoidXNlciIsIlgtaGFzdXJhLXVzZXItaWQiOiI5OTY5OSJ9LCJ1c2VyIjp7ImlkIjo5OTY5OX19.QpbCDzDy-HCioc2EAzL_asvki_xvMqmeBcNoihx9_hM';
    const urlApi = 'https://api.hardcover.app/v1/graphql';

    final queryGraphQL =
        '''
      query GetEditionByISBN {
        editions(where: { 
          _or: [
            { isbn_13: { _in: $arrayDeIsbnsFormatado } }, 
            { isbn_10: { _in: $arrayDeIsbnsFormatado } }
          ] 
        }) {
          title
          publisher { name }
          image { url }
          book {
            description
            contributions { author { name } }
            taggings {
              tag {
                tag
              }
            }
          }
        }
      }
    ''';

    final respostaApi = await http.post(
      Uri.parse(urlApi),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': tokenAutenticacao,
      },
      body: jsonEncode({'query': queryGraphQL}),
    );

    if (respostaApi.statusCode != 200) return null;

    final dadosDecodificados = jsonDecode(respostaApi.body);
    if (dadosDecodificados.containsKey('errors')) return null;

    final edicoesEncontradas = dadosDecodificados['data']?['editions'] as List?;
    if (edicoesEncontradas == null || edicoesEncontradas.isEmpty) return null;

    return await _mostrarEdicaoEncontrada(edicoesEncontradas.first);
  }

  // Método para auxiliar na geração de variações do ISBN para a consulta na API
  List<String> _gerarVariacoesDoIsbn(String isbnLimpo) {
    List<String> variacoes = [isbnLimpo];
    if (isbnLimpo.length == 13) {
      variacoes.add('${isbnLimpo.substring(0, 3)}-${isbnLimpo.substring(3)}');
      variacoes.add(
        '${isbnLimpo.substring(0, 3)}-${isbnLimpo.substring(3, 5)}-${isbnLimpo.substring(5, 9)}-${isbnLimpo.substring(9, 12)}-${isbnLimpo.substring(12)}',
      );
    } else if (isbnLimpo.length == 10) {
      variacoes.add(
        '${isbnLimpo.substring(0, 2)}-${isbnLimpo.substring(2, 5)}-${isbnLimpo.substring(5, 9)}-${isbnLimpo.substring(9)}',
      );
    }
    return variacoes;
  }

  Future<Map<String, dynamic>> _mostrarEdicaoEncontrada(
    Map<String, dynamic> dadosDoLivro,
  ) async {
    String titulo = dadosDoLivro['title'] ?? '';
    String editora = dadosDoLivro['publisher']?['name'] ?? '';
    String autor = '';
    String generosFormatados = '';
    String sinopse = '';
    Uint8List? imagemCapa;

    // Extrair Autor
    final listaDeAutores = dadosDoLivro['book']?['contributions'] as List?;
    if (listaDeAutores != null && listaDeAutores.isNotEmpty) {
      autor = listaDeAutores
          .map((m) => m['author']?['name'])
          .where((x) => x != null)
          .join(', ');
    }

    // Extrai e traz os gêneros traduzidos
    final listaDeCategorias = dadosDoLivro['book']?['taggings'] as List?;
    if (listaDeCategorias != null && listaDeCategorias.isNotEmpty) {
      List<String> categoriasEmIngles = listaDeCategorias
          .map((m) => m['tag']?['tag']?.toString())
          .where((x) => x != null)
          .cast<String>()
          .toList();

      generosFormatados = await _limparETraduzirGeneros(categoriasEmIngles);
    }

    // Traz o texto da sinopse traduzida
    String resumoEmIngles = dadosDoLivro['book']?['description'] ?? '';
    if (resumoEmIngles.isNotEmpty) {
      try {
        final resumoEmPortugues = await _tradutor.translate(
          resumoEmIngles,
          to: 'pt',
        );
        sinopse = resumoEmPortugues.text;
      } catch (_) {
        sinopse = resumoEmIngles;
      }
    }

    // Trás a imagem da capa do livro
    final linkCapa = dadosDoLivro['image']?['url'];
    if (linkCapa != null) {
      try {
        final urlHttps = linkCapa.replaceAll('http:', 'https:');
        final respostaImagem = await http.get(Uri.parse(urlHttps));
        if (respostaImagem.statusCode == 200) {
          imagemCapa = respostaImagem.bodyBytes;
        }
      } catch (_) {}
    }

    return {
      'titulo': titulo,
      'autor': autor,
      'editora': editora,
      'generos': generosFormatados,
      'sinopse': sinopse,
      'capa': imagemCapa,
    };
  }

  // Traz os generos ja limpos e tradzidos, limitando a 4 generos para nao poluir e evitar erros
  Future<String> _limparETraduzirGeneros(List<String> generosBrutos) async {
    Set<String> generosFiltrados = {};
    for (String generoBruto in generosBrutos) {
      List<String> separados = generoBruto.split(',');
      for (String genero in separados) {
        String textoLimpo = genero.trim();
        String textoMinusculo = textoLimpo.toLowerCase();

        if (textoLimpo.isEmpty ||
            textoLimpo.contains(':') ||
            textoLimpo.contains('='))
          continue;
        if (textoMinusculo.contains('literatura') ||
            textoMinusculo.contains('literature') ||
            textoLimpo.contains('(') ||
            textoLimpo.contains(')'))
          continue;
        
        if (textoLimpo.length > 1) {
          textoLimpo =
              textoLimpo[0].toUpperCase() +
              textoLimpo.substring(1).toLowerCase();
        }
        generosFiltrados.add(textoLimpo);
      }
    }

    List<String> resultadoFinal = generosFiltrados.toList();
    if (resultadoFinal.length > 4)
      resultadoFinal = resultadoFinal.sublist(0, 4);
    String textoEmIngles = resultadoFinal.join(', ');

    if (textoEmIngles.isNotEmpty) {
      try {
        final generosTraduzidos = await _tradutor.translate(
          textoEmIngles,
          to: 'pt',
        );
        return generosTraduzidos.text
            .split(',')
            .map((g) {
              String generoLimpo = g.trim();
              if (generoLimpo.isEmpty) return generoLimpo;
              return generoLimpo[0].toUpperCase() +
                  generoLimpo.substring(1).toLowerCase();
            })
            .join(', ');
      } catch (_) {}
    }
    return textoEmIngles;
  }

  Stream<List<Book>> obterLivrosDoUsuario(String idDoUsuario) {
    return _firestore
        .collection('books')
        .where('userId', isEqualTo: idDoUsuario)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final dadosCorrigidos = _corrigirDadosDoLivro(doc.data());
            return Book.fromMap(dadosCorrigidos, doc.id);
          }).toList();
        });
  }

  //Deletar Livros
  Future<void> deletarLivro(String idDoLivro) async {
  await _firestore.collection('books').doc(idDoLivro).delete();
}

  Map<String, dynamic> _corrigirDadosDoLivro(
    Map<String, dynamic> dadosOriginais,
  ) {
    final dadosCorrigidos = Map<String, dynamic>.from(dadosOriginais);

    if (dadosCorrigidos['genres'] is String) {
      final String textoDoGenero = dadosCorrigidos['genres'] ?? '';
      dadosCorrigidos['genres'] = textoDoGenero.isNotEmpty
          ? textoDoGenero.split(',').map((genero) => genero.trim()).toList()
          : <String>[];
    }

    return dadosCorrigidos;
  }
}