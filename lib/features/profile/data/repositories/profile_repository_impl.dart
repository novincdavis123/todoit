import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfile?> getProfile(String uid) {
    return remoteDataSource.getProfile(uid);
  }

  @override
  Future<void> updateProfile(UserProfile profile) {
    return remoteDataSource.updateProfile(profile);
  }
}
