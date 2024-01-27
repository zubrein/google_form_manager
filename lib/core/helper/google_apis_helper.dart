import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis/drive/v2.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:googleapis/youtube/v3.dart';

import 'google_auth_helper.dart';

class GoogleApisHelper {
  static Future<DriveApi?> getDriveApi() async {
    var httpClient = await googleSigning.authenticatedClient();

    DriveApi? driveApi;

    if (httpClient != null) {
      driveApi = DriveApi(httpClient);
    }

    return driveApi;
  }

  static Future<FormsApi?> getFormApi() async {
    var httpClient = await googleSigning.authenticatedClient();

    FormsApi? formsApi;

    if (httpClient != null) {
      formsApi = FormsApi(httpClient);
    }

    return formsApi;
  }

  static Future<YouTubeApi?> getYoutubeApi() async {
    var httpClient = await googleSigning.authenticatedClient();

    YouTubeApi? youTubeApi;

    if (httpClient != null) {
      youTubeApi = YouTubeApi(httpClient);
    }

    return youTubeApi;
  }
}
