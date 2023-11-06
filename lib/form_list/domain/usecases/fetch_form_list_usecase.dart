import 'package:google_form_manager/form_list/domain/repositories/form_list_repository.dart';
import 'package:googleapis/drive/v2.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchFormListUseCase {
  FormListRepository repository;

  FetchFormListUseCase({required this.repository});

  Future<List<File>> call() async {
    return await repository.fetchFormListFromRemote();
  }
}
