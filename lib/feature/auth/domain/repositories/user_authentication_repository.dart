abstract class UserAuthenticationRepository {
  Future<void> signingIn();

  Future<void> logout();
}
