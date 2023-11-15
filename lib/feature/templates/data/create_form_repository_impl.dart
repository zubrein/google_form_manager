import 'package:google_form_manager/core/helper/google_apis_helper.dart';
import 'package:google_form_manager/feature/templates/domain/repositories/create_form_repository.dart';
import 'package:googleapis/drive/v2.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CreateFormRepository)
class CreateFormRepositoryImpl extends CreateFormRepository {
  @override
  Future<String> createForm(String formName, Form formData) {
    return _createForm(formName, formData);
  }

  Future<String> _createForm(String formName, Form formData) async {
    final formApi = await GoogleApisHelper.getFormApi();

    if (formApi != null) {
      final response = await formApi.forms.create(formData);
      if (response.formId != null) {
        return _renameForm(formName, response.formId!);
      }
    }
    return '';
  }

  Future<String> _renameForm(String formName, String formId) async {
    var driveApi = await GoogleApisHelper.getDriveApi();

    if (driveApi != null) {
      final newFile = File()..title = formName;

      final file = await driveApi.files.update(newFile, formId);

      if (file.id != null) return formId;
    }
    return formId;
  }
}
