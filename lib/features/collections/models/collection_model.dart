class Collection {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final String? coverUrl;
  final List<String> bookIds;
  final DateTime createdAt;

  Collection({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.coverUrl,
    this.bookIds = const [],
    required this.createdAt,
  }) {
    if (id.isEmpty) throw ArgumentError('id não pode ser vazio');
    if (userId.isEmpty) throw ArgumentError('userId não pode ser vazio');
    if (name.isEmpty) throw ArgumentError('nome não pode ser vazio');
    if (bookIds.length != bookIds.toSet().length) throw ArgumentError('bookIds não pode conter duplicatas');
  }

  int get bookCount => bookIds.length;

  bool containsBook(String bookId) => bookIds.contains(bookId);

  Collection addBook(String bookId) {
    if (bookId.isEmpty) throw ArgumentError('bookId não pode ser vazio');
    if (containsBook(bookId)) return this;
    return copyWith(bookIds: [...bookIds, bookId]);
  }

  Collection removeBook(String bookId) {
    if (!containsBook(bookId)) return this;
    return copyWith(bookIds: bookIds.where((id) => id != bookId).toList());
  }

  Collection rename(String newName) {
    if (newName.isEmpty) throw ArgumentError('nome não pode ser vazio');
    return copyWith(name: newName);
  }

  Collection copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? coverUrl,
    List<String>? bookIds,
    DateTime? createdAt,
  }) {
    return Collection(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      bookIds: bookIds ?? this.bookIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
