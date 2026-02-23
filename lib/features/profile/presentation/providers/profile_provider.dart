import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_profile.dart';

class ProfileNotifier extends Notifier<UserProfile?> {
  final FirebaseAuth auth;

  ProfileNotifier(this.auth);

  @override
  UserProfile? build() {
    final currentUser = auth.currentUser;
    if (currentUser == null) return null;
    return UserProfile(
      uid: currentUser.uid,
      name: currentUser.displayName ?? '',
      email: currentUser.email ?? '',
      isDarkMode: false, // default
    );
  }

  Future<void> updateProfile(UserProfile profile) async {
    // Update Firebase Auth displayName if needed
    await auth.currentUser?.updateDisplayName(profile.name);
    state = profile; // update local state
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, UserProfile?>(
  () => ProfileNotifier(FirebaseAuth.instance),
);
