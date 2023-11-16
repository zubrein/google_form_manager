import 'package:injectable/injectable.dart';

import '../repositories/form_list_repository.dart';

@injectable
class DeleteFormListUseCase {
  FormListRepository repository;

  DeleteFormListUseCase({required this.repository});

  Future<bool> call(String formId) async {
    return await repository.deleteForm(formId);
  }
}
