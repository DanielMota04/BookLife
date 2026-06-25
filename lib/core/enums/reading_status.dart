enum ReadingStatus { reading, completed, wishlist }

extension ReadingStatusLabel on ReadingStatus {
  String get displayName => switch (this) {
    ReadingStatus.reading => 'Lendo',
    ReadingStatus.completed => 'Lido',
    ReadingStatus.wishlist => 'Em espera',
  };
}
