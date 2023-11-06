import 'package:google_form_manager/auth/domain/repositories/user_authentication_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SigningInUseCase {
  UserAuthenticationRepository repository;

  SigningInUseCase({required this.repository});

  Future<void> call() async {
    return repository.signingIn();
  }
}
