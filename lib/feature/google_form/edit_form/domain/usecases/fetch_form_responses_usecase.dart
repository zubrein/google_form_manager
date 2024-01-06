import 'package:googleapis/forms/v1.dart';
import 'package:injectable/injectable.dart';

import '../repository/edit_form_repository.dart';

@injectable
class FetchFormResponsesUseCase {
  final EditFormRepository repository;

  FetchFormResponsesUseCase(this.repository);

  Future<List<FormResponse>> call(String formId) async {
    return await repository.getResponses(formId);
  }
}
