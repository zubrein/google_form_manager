import 'package:google_form_manager/core/helper/google_apis_helper.dart';
import 'package:google_form_manager/core/helper/logger.dart';
import 'package:google_form_manager/form_list/domain/repositories/form_list_repository.dart';
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
          .list(q: "mimeType = 'application/vnd.google-apps.form'");
      formList = fileList.items ?? [];
    } else {
      Log.info('Drive api not found');
    }

    return formList;
  }
}
