import 'package:dartz/dartz.dart';
import 'package:google_form_manager/core/helper/google_apis_helper.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository/edit_form_repository.dart';

@Injectable(as: EditFormRepository)
class EditFormRepositoryImpl extends EditFormRepository {
  @override
  Future<Either<Form?, String>> bachUpdate(
    BatchUpdateFormRequest batchUpdateRequest,
    String formId,
  ) async {
    final formApi = await GoogleApisHelper.getFormApi();

    try {
      final response = await formApi?.forms.batchUpdate(
        batchUpdateRequest,
        formId,
      );
      return Left(response?.form);
    } catch (error) {
      return Right(error.toString());
    }
  }

  @override
  Future<Form?> getForm(String formId) async {
    final formApi = await GoogleApisHelper.getFormApi();
    Form? form;
    if (formApi != null) {
      form = await formApi.forms.get(formId);
    }
    return form;
  }

  @override
  Future<List<FormResponse>> getResponses(String formId) async {
    final formApi = await GoogleApisHelper.getFormApi();
    ListFormResponsesResponse formResponses;
    if (formApi != null) {
      formResponses = await formApi.forms.responses.list(formId);
      return formResponses.responses ?? [];
    }
    return [];
  }

  @override
  Future<SearchListResponse> getVideoList(String query) async {
    final youtubeApi = await GoogleApisHelper.getYoutubeApi();

    SearchListResponse searchListResponse = SearchListResponse();
    if (youtubeApi != null) {
      try {
        searchListResponse = await youtubeApi.search.list(
          ['snippet'],
          q: query,
          maxResults: 20,
        );
      } catch (error) {
        print('Error fetching videos: $error');
        return SearchListResponse(); // Return an empty list if an error occurs
      }
    }

    return searchListResponse;
  }
}
