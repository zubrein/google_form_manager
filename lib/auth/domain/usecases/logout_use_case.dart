import 'package:google_form_manager/auth/domain/repositories/user_authentication_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUseCase {
  UserAuthenticationRepository repository;

  LogoutUseCase({required this.repository});

  Future<void> call() async {
    return repository.logout();
  }
}
