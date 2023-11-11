import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/forms/v1.dart';

final GoogleSignIn googleSigning = GoogleSignIn(scopes: [
  FormsApi.driveScope,
  FormsApi.formsBodyScope,
]);

class GoogleAuthHelper {
  void init() {
    googleSigning.signInSilently();
  }
}
