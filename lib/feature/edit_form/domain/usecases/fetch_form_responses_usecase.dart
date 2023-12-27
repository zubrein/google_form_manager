import 'package:google_form_manager/feature/edit_form/domain/repository/edit_form_repository.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchFormResponsesUseCase {
  final EditFormRepository repository;

  FetchFormResponsesUseCase(this.repository);

  Future<List<FormResponse>> call(String formId) async {
    return await repository.getResponses(formId);
  }
}
