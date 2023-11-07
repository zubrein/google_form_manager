import 'package:google_form_manager/feature/edit_form/domain/repository/edit_form_repository.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:injectable/injectable.dart';

@injectable
class BatchUpdateUseCase {
  final EditFormRepository repository;

  BatchUpdateUseCase(this.repository);

  Future<bool> call(BatchUpdateFormRequest request, String formId) async {
    return await repository.bachUpdate(request, formId);
  }
}
