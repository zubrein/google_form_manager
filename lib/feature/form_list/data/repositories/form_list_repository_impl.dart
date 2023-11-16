import 'package:google_form_manager/core/helper/google_apis_helper.dart';
import 'package:google_form_manager/core/helper/logger.dart';
import 'package:google_form_manager/feature/form_list/domain/repositories/form_list_repository.dart';
import 'package:googleapis/drive/v2.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FormListRepository)
class FormListRepositoryImpl extends FormListRepository {
  @override
  Future<List<File>> fetchFormListFromRemote() async {
    List<File> formList = [];
    final driveApi = await GoogleApisHelper.getDriveApi();

    if (driveApi != null) {
      final fileList = await driveApi.files
          .list(q: "mimeType = 'application/vnd.google-apps.form' and trashed=false");
      formList = fileList.items ?? [];
    } else {
      Log.info('Drive api not found');
    }

    return formList;
  }
  @override
  Future<bool> deleteForm(String formId) async {
    var driveApi = await GoogleApisHelper.getDriveApi();
    if (driveApi != null) {
      try {
        await driveApi.files.delete(formId);
        return true;
      } catch (error) {
        return false;
      }
    } else {
      return false;
    }
  }
}
