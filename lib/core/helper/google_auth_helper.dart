import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis/youtube/v3.dart';

final GoogleSignIn googleSigning = GoogleSignIn(scopes: [
  FormsApi.driveScope,
  FormsApi.formsBodyScope,
  YouTubeApi.youtubeReadonlyScope,
  SheetsApi.spreadsheetsScope,
]);

class GoogleAuthHelper {
  void init() {
    googleSigning.signInSilently();
  }
}
