import 'package:googleapis/drive/v2.dart';

abstract class FormListRepository {
  Future<List<File>> fetchFormListFromRemote();
  Future<bool> deleteForm(String formId);
}
