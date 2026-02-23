import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoit/features/profile/domain/usecases/profile_usecase.dart';
import '../../domain/entities/user_profile.dart';

class ProfileNotifier extends Notifier<UserProfile?> {
  late final GetProfileUseCase getProfileUseCase;
  late final UpdateProfileUseCase updateProfileUseCase;

  @override
  UserProfile? build() {
    return null; // initial state
  }

  Future<void> loadProfile(String uid) async {
    state = await getProfileUseCase(uid);
  }

  Future<void> updateProfile(UserProfile profile) async {
    await updateProfileUseCase(profile);
    state = profile; // optimistic update
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, UserProfile?>(
  () => ProfileNotifier(),
);
