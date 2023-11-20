import 'package:google_form_manager/core/helper/google_apis_helper.dart';
import 'package:google_form_manager/core/helper/logger.dart';
import 'package:google_form_manager/feature/edit_form/domain/repository/edit_form_repository.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: EditFormRepository)
class EditFormRepositoryImpl extends EditFormRepository {
  @override
  Future<bool> bachUpdate(
    BatchUpdateFormRequest batchUpdateRequest,
    String formId,
  ) async {
    final formApi = await GoogleApisHelper.getFormApi();

    if (formApi != null) {
      try {
        final response = await formApi.forms.batchUpdate(
          batchUpdateRequest,
          formId,
        );
        if (response.form != null) {
          return true;
        } else {
          return false;
        }
      } catch (error) {
        Log.info(error.toString());
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Future<Form?> getForm(String formId) async {
    final formApi = await GoogleApisHelper.getFormApi();
    Form? form;
    if (formApi != null) {
      form = await formApi.forms.get(formId);
    }
    return form;
  }
}
