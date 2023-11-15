import 'package:googleapis/forms/v1.dart';

abstract class CreateFormRepository {
  Future<String> createForm(String formName, Form formData);
}
