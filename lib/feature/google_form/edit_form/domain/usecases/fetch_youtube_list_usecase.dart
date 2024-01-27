import 'package:googleapis/youtube/v3.dart';
import 'package:injectable/injectable.dart';

import '../repository/edit_form_repository.dart';

@injectable
class FetchYoutubeListUseCase {
  final EditFormRepository repository;

  FetchYoutubeListUseCase(this.repository);

  Future<SearchListResponse?> call(String query) async {
    return await repository.getVideoList(query);
  }
}
