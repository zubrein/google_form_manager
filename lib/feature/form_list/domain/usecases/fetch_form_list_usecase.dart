import 'package:googleapis/drive/v2.dart';
import 'package:injectable/injectable.dart';

import '../repositories/form_list_repository.dart';

@injectable
class FetchFormListUseCase {
  FormListRepository repository;

  FetchFormListUseCase({required this.repository});

  Future<List<File>> call() async {
    return await repository.fetchFormListFromRemote();
  }
}
