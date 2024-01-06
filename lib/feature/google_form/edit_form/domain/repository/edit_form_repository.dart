import 'package:dartz/dartz.dart';
import 'package:googleapis/forms/v1.dart';

abstract class EditFormRepository {
  Future<Form?> getForm(String formId);

  Future<List<FormResponse>> getResponses(String formId);

  Future<Either<Form?, String>> bachUpdate(
    BatchUpdateFormRequest batchUpdateRequest,
    String formId,
  );
}
