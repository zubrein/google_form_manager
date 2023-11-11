import 'package:google_form_manager/feature/templates/domain/repositories/create_form_repository.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateFormUseCase {
  final CreateFormRepository repository;

  CreateFormUseCase(this.repository);

  Future<bool> call(String formName) async {
    return repository.createForm(formName, _prepareCreateFormData(formName));
  }

  Form _prepareCreateFormData(String formName) {
    return Form(info: Info(title: formName));
  }
}
