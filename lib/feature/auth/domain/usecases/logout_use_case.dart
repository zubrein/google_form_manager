import 'package:injectable/injectable.dart';

import '../repositories/user_authentication_repository.dart';

@injectable
class LogoutUseCase {
  UserAuthenticationRepository repository;

  LogoutUseCase({required this.repository});

  Future<void> call() async {
    return repository.logout();
  }
}
