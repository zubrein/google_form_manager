import 'package:google_form_manager/feature/edit_form/domain/repository/edit_form_repository.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchFormUseCase {
  final EditFormRepository repository;

  FetchFormUseCase(this.repository);

  Future<Form?> call(String formId) async {
    return await repository.getForm(formId);
  }
}
