import 'package:googleapis/forms/v1.dart';

abstract class EditFormRepository {
  Future<Form?> getForm(String formId);

  Future<bool> bachUpdate(
    BatchUpdateFormRequest batchUpdateRequest,
    String formId,
  );
}
