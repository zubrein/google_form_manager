abstract class UserAuthenticationRepository {
  Future<void> signingIn();

  void logout();
}
