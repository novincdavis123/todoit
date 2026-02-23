import '../../domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends User {
  final bool isDarkMode;

  UserModel({
    required super.uid,
    required super.name,
    required super.email,
    this.isDarkMode = false,
  });

  /// Factory constructor to create a UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data();

    if (data == null) {
      return UserModel(uid: doc.id, name: '', email: '');
    }

    final map = data as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      isDarkMode: map['themeMode'] ?? false,
    );
  }

  /// Convert UserModel to Firestore-compatible map
  Map<String, dynamic> toFirestore() => {
    'name': name,
    'email': email,
    'themeMode': isDarkMode,
    'createdAt': FieldValue.serverTimestamp(),
  };

  /// Return a copy with updated fields
  UserModel copyWith({String? name, String? email, bool? isDarkMode}) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
