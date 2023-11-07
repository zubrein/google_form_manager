import 'package:injectable/injectable.dart';

import '../repositories/user_authentication_repository.dart';

@injectable
class SigningInUseCase {
  UserAuthenticationRepository repository;

  SigningInUseCase({required this.repository});

  Future<void> call() async {
    return repository.signingIn();
  }
}
