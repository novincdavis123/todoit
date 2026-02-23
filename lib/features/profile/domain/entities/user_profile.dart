class UserProfile {
  final String uid;
  final String name;
  final String email;
  final bool isDarkMode;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.isDarkMode,
  });

  UserProfile copyWith({String? name, String? email, bool? isDarkMode}) {
    return UserProfile(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
