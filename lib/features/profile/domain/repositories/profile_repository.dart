import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile?> getProfile(String uid);
  Future<void> updateProfile(UserProfile profile);
}
