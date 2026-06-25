class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime createdAt;
  final Map<String, DateTime> completedAchievements;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.createdAt,
    this.completedAchievements = const {},
  }) {
    if (id.isEmpty) throw ArgumentError('id não pode ser vazio');
    if (name.isEmpty) throw ArgumentError('nome não pode ser vazio');
    if (email.isEmpty) throw ArgumentError('email não pode ser vazio');
  }

  bool hasAchievement(String achievementId) =>
      completedAchievements.containsKey(achievementId);

  int get achievementCount => completedAchievements.length;

  User unlockAchievement(String achievementId) {
    if (completedAchievements.containsKey(achievementId)) return this;

    return copyWith(
      completedAchievements: {
        ...completedAchievements,
        achievementId: DateTime.now(),
      },
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
    Map<String, DateTime>? completedAchievements,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      completedAchievements:
          completedAchievements ?? this.completedAchievements,
    );
  }
}
