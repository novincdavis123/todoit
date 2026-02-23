import '../../domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends User {
  UserModel({required super.uid, required super.name, required super.email});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'email': email,
    'createdAt': FieldValue.serverTimestamp(),
  };
}
