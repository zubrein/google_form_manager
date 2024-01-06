import 'package:dartz/dartz.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:injectable/injectable.dart';

import '../repository/edit_form_repository.dart';

@injectable
class BatchUpdateUseCase {
  final EditFormRepository repository;

  BatchUpdateUseCase(this.repository);

  Future<Either<Form?, String>> call(
      BatchUpdateFormRequest request, String formId) async {
    return await repository.bachUpdate(request, formId);
  }
}
