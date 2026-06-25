import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_life/core/enums/reading_status.dart';

class Book {
  final String id;
  final String userId;
  final String title;
  final String author;
  final String? isbn;
  final String? publisher;
  final List<String> genres;
  final String? synopsis;
  final String? coverUrl;
  final Uint8List? coverBytes;
  final int totalPages;
  final int currentPage;
  final ReadingStatus status;
  final double? rating;
  final bool isFavorite;
  final String? review;
  final DateTime addedAt;

  Book({
    required this.id,
    required this.userId,
    required this.title,
    required this.author,
    this.isbn,
    this.publisher,
    this.genres = const [],
    this.synopsis,
    this.coverUrl,
    this.coverBytes,
    required this.totalPages,
    this.currentPage = 0,
    this.status = ReadingStatus.wishlist,
    this.rating,
    this.isFavorite = false,
    this.review,
    required this.addedAt,
  }) {
    if (id.isEmpty) throw ArgumentError('id não pode ser vazio');
    if (userId.isEmpty) throw ArgumentError('userId não pode ser vazio');
    if (title.isEmpty) throw ArgumentError('título não pode ser vazio');
    if (totalPages < 0) throw ArgumentError('O total de páginas não pode ser negativo');
    if (currentPage < 0) throw ArgumentError('A página atual não pode ser negativo');
    if (currentPage > totalPages) throw ArgumentError('A página atual não pode ser maior que o total de páginas');
    if (rating != null && (rating! < 0 || rating! > 10)) throw ArgumentError('A avaliação deve estar entre 0 e 10');
  }

  double get progressPercentage =>
      totalPages > 0 ? currentPage / totalPages : 0.0;

  int get displayProgressPercentage {
    if (totalPages <= 0) return 0;
    if (currentPage >= totalPages) return 100;
    return ((currentPage / totalPages) * 100).ceil().clamp(0, 100);
  }
  
  bool get isInProgress => status == ReadingStatus.reading;

  bool get isCompleted => status == ReadingStatus.completed;

  Book markAsReading() => copyWith(status: ReadingStatus.reading);

  Book markAsCompleted() =>
      copyWith(status: ReadingStatus.completed, currentPage: totalPages);

  Book markAsWishlist() => copyWith(status: ReadingStatus.wishlist);

  Book updateProgress(int newPage) {
    if (newPage < 0) throw ArgumentError('A página atual não pode ser negativo');
    if (newPage > totalPages) {
      throw ArgumentError('A página atual não pode ser maior que o total de páginas');
    }

    return copyWith(
      currentPage: newPage,
      status: newPage == totalPages ? ReadingStatus.completed : status,
    );
  }

  Book toggleFavorite() => copyWith(isFavorite: !isFavorite);

  Book rate(double newRating) {
    if (newRating < 0 || newRating > 10) {
      throw ArgumentError('A avaliação deve estar entre 0 e 10');
    }
    return copyWith(rating: newRating);
  }

  Book copyWith({
    String? id,
    String? userId,
    String? title,
    String? author,
    String? isbn,
    String? publisher,
    List<String>? genres,
    String? synopsis,
    String? coverUrl,
    Uint8List? coverBytes,
    int? totalPages,
    int? currentPage,
    ReadingStatus? status,
    double? rating,
    bool? isFavorite,
    String? review,
    DateTime? addedAt,
  }) {
    return Book(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      author: author ?? this.author,
      isbn: isbn ?? this.isbn,
      publisher: publisher ?? this.publisher,
      genres: genres ?? this.genres,
      synopsis: synopsis ?? this.synopsis,
      coverUrl: coverUrl ?? this.coverUrl,
      coverBytes: coverBytes ?? this.coverBytes,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      review: review ?? this.review,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'author': author,
      'isbn': isbn,
      'publisher': publisher,
      'genres': genres,
      'synopsis': synopsis,
      'coverUrl': coverUrl,
      'coverBase64': coverBytes != null ? base64Encode(coverBytes!) : null,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'status': status.name,
      'rating': rating,
      'isFavorite': isFavorite,
      'review': review,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  factory Book.fromMap(Map<String, dynamic> map, String documentId) {
    Uint8List? imagemDecodificada;
    if (map['coverBase64'] != null) {
      try {
        imagemDecodificada = base64Decode(map['coverBase64']);
      } catch (_) {
      }
    }

    DateTime dataConvertida = DateTime.now();
    if (map['addedAt'] is Timestamp) {
      dataConvertida = (map['addedAt'] as Timestamp).toDate();
    }

    ReadingStatus statusConvertido = ReadingStatus.reading;
    if (map['status'] != null) {
      statusConvertido = ReadingStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ReadingStatus.reading,
      );
    }

    return Book(
      id: documentId,
      userId: map['userId'] ?? '',
      title: map['title'] ?? 'Sem Título',
      author: map['author'] ?? '',
      isbn: map['isbn'],
      publisher: map['publisher'],
      genres: List<String>.from(map['genres'] ?? []),
      synopsis: map['synopsis'],
      coverUrl: map['coverUrl'],
      coverBytes: imagemDecodificada,
      totalPages: map['totalPages']?.toInt() ?? 0,
      currentPage: map['currentPage']?.toInt() ?? 0,
      status: statusConvertido,
      rating: map['rating']?.toDouble(),
      isFavorite: map['isFavorite'] ?? false,
      review: map['review'],
      addedAt: dataConvertida,
    );
  }
}