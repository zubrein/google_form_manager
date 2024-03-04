import 'package:dartz/dartz.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:googleapis/youtube/v3.dart';

abstract class EditFormRepository {
  Future<Form?> getForm(String formId);

  Future<List<FormResponse>> getResponses(String formId);

  Future<Either<Form?, String>> bachUpdate(
    BatchUpdateFormRequest batchUpdateRequest,
    String formId,
  );

  Future<SearchListResponse> getVideoList(String query);

  Future<void> saveToSheet(String formId, List<List<String>> values);
}
