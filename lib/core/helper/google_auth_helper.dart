import 'package:google_form_manager/auth/domain/entities/user_profile_entity.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/forms/v1.dart';

final GoogleSignIn googleSigning = GoogleSignIn(scopes: [
  FormsApi.driveScope,
  FormsApi.formsBodyScope,
]);

class GoogleAuthHelper {
  UserProfile user = UserProfile();

  void init() {
    googleSigning.signInSilently();
  }
}
