import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoit/core/error/app_exceptions.dart';
import '../../domain/entities/user_profile.dart';

class ProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  ProfileRemoteDataSource({required this.firestore});

  Future<UserProfile?> getProfile(String uid) async {
    try {
      final doc = await firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      final data = doc.data()!;
      return UserProfile(
        uid: uid,
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        isDarkMode: data['themeMode'] ?? false,
      );
    } catch (e) {
      throw CacheException('Failed to fetch profile: $e');
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    try {
      await firestore.collection('users').doc(profile.uid).update({
        'name': profile.name,
        'themeMode': profile.isDarkMode,
      });
    } catch (e) {
      throw CacheException('Failed to update profile: $e');
    }
  }
}
