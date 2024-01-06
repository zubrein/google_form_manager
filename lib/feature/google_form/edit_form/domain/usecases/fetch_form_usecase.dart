import 'package:googleapis/forms/v1.dart';
import 'package:injectable/injectable.dart';

import '../repository/edit_form_repository.dart';

@injectable
class FetchFormUseCase {
  final EditFormRepository repository;

  FetchFormUseCase(this.repository);

  Future<Form?> call(String formId) async {
    return await repository.getForm(formId);
  }
}
