import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:google_form_manager/core/helper/google_apis_helper.dart';
import 'package:googleapis/drive/v2.dart' as drive;

class ImagePickerHelper {
  static Future<String?> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png'],
      );

      if (result != null) {
        final dUrl = uploadImage(result.files.single.path!);
        return dUrl;
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
    return null;
  }
}

Future<String> uploadImage(String filePath) async {
  final driveApi = await GoogleApisHelper.getDriveApi();

  final File file = File(filePath);

  final drive.Media media = drive.Media(
    file.openRead(),
    File(filePath).lengthSync(),
    contentType: 'image/jpeg',
  );

  final drive.File dFile = drive.File();
  dFile.title = 'MyImage.jpg';

  final result = await driveApi?.files.insert(dFile, uploadMedia: media);
  await driveApi?.permissions.insert(
    drive.Permission.fromJson({
      'role': 'reader',
      'type': 'anyone',
    }),
    result!.id!,
  );

  return result?.webContentLink ?? '';
}
