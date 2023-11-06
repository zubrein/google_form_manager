import '../entities/user_profile_entity.dart';

abstract class UserAuthenticationRepository {
  Future<void> signingIn();

  Future<void> logout();
}
