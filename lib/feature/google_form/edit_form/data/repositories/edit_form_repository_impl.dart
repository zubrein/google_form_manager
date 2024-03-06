import 'package:dartz/dartz.dart';
import 'package:google_form_manager/core/helper/google_apis_helper.dart';
import 'package:googleapis/drive/v2.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:googleapis/sheets/v4.dart';
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
  Future<void> saveToSheet(String formId, List<List<String>> values) async {
    final sheetsApi = await GoogleApisHelper.getSheetsApi();
    String sheetId = '';

    final sheetList = await _fetchSheetListFromRemote();

    for (var sheet in sheetList) {
      if (sheet.title == formId) {
        sheetId = sheet.id!;
      }
    }

    if (sheetId.isNotEmpty) {
      final isDeleted = await _deleteSheet(sheetId);
      if (isDeleted) {
        if (sheetsApi != null) {
          await _createSheet(sheetsApi, formId, values);
        }
      }
    } else {
      if (sheetsApi != null) {
        await _createSheet(sheetsApi, formId, values);
      }
    }
  }

  @override
  Future<String> sheetUrl(String formId) async {
    String sheetId = '';

    final sheetList = await _fetchSheetListFromRemote();

    for (var sheet in sheetList) {
      if (sheet.title == formId) {
        sheetId = sheet.id!;
      }
    }

    return sheetId.isNotEmpty ? sheetId : '';
  }

  Future<List<File>> _fetchSheetListFromRemote() async {
    List<File> sheetList = [];
    final driveApi = await GoogleApisHelper.getDriveApi();

    if (driveApi != null) {
      final fileList = await driveApi.files.list(
          q: "mimeType = 'application/vnd.google-apps.spreadsheet' and trashed=false");
      sheetList = fileList.items ?? [];
    }

    return sheetList;
  }

  Future<void> _createSheet(
      SheetsApi sheetsApi, String formId, List<List<String>> values) async {
    final createdSheet = await sheetsApi.spreadsheets.create(Spreadsheet(
        properties: SpreadsheetProperties(
      title: formId,
    )));

    _insertData(sheetsApi, createdSheet.spreadsheetId!, values);
  }

  Future<void> _insertData(SheetsApi sheetsApi, String spreadsheetId,
      List<List<String>> values) async {
    final requestBody = ValueRange()..values = values;

    try {
      await sheetsApi.spreadsheets.values.append(
          requestBody, spreadsheetId, 'Sheet1!A1',
          valueInputOption: 'RAW');
      print('Data inserted successfully.');
    } catch (e) {
      print('Error inserting data: $e');
    }
  }

  Future<bool> _deleteSheet(String sheetId) async {
    var driveApi = await GoogleApisHelper.getDriveApi();
    if (driveApi != null) {
      try {
        await driveApi.files.delete(sheetId);
        return true;
      } catch (error) {
        return false;
      }
    } else {
      return false;
    }
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
