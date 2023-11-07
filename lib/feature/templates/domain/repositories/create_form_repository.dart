import 'package:googleapis/forms/v1.dart';

abstract class CreateFormRepository {
  Future<bool> createForm(String formName, Form formData);
}
