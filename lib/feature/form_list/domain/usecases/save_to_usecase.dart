import 'package:injectable/injectable.dart';

import '../../../google_form/edit_form/domain/repository/edit_form_repository.dart';

@injectable
class SaveToSheetUseCase {
  EditFormRepository repository;

  SaveToSheetUseCase({required this.repository});

  Future<void> call(String formId, List<List<String>> values) async {
    return await repository.saveToSheet(formId, values);
  }

  Future<String> fetchSheetId(String formId) async {
    return await repository.sheetUrl(formId);
  }
}
