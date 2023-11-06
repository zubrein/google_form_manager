import 'package:google_form_manager/auth/domain/repositories/user_authentication_repository.dart';
import 'package:google_form_manager/core/helper/google_auth_helper.dart';
import 'package:google_form_manager/core/helper/logger.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UserAuthenticationRepository)
class UserAuthRepositoryImpl extends UserAuthenticationRepository {
  @override
  Future<void> signingIn() async {
    try {
      await googleSigning.signIn();
    } catch (error) {
      Log.info(error.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      googleSigning.disconnect();
    } catch (error) {
      Log.info(error.toString());
    }
  }
}
