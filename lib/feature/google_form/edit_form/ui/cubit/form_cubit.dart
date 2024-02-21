import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_form_manager/core/helper/google_apis_helper.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/entities/question_answer_entity.dart';
import 'package:google_form_manager/util/utility.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:injectable/injectable.dart';

import '../../domain/constants.dart';
import '../../domain/entities/base_item_entity.dart';
import '../../domain/entities/move_item_entity.dart';
import '../../domain/entities/response_entity.dart';
import '../../domain/enums.dart';
import '../../domain/usecases/batch_update_usecase.dart';
import '../../domain/usecases/check_question_type_usecase.dart';
import '../../domain/usecases/fetch_form_responses_usecase.dart';
import '../../domain/usecases/fetch_form_usecase.dart';
import '../../domain/usecases/fetch_youtube_list_usecase.dart';
import '../utils/process_request_for_empty_feedback.dart';
import '../widgets/helper/create_request_item_helper.dart';
import '../widgets/helper/delete_request_item_helper.dart';

part 'form_state.dart';

@injectable
class FormCubit extends Cubit<EditFormState> {
  FetchFormUseCase fetchFormUseCase;
  CheckQuestionTypeUseCase checkQuestionTypeUseCase;
  FetchFormResponsesUseCase fetchFormResponsesUseCase;
  FetchYoutubeListUseCase fetchYoutubeListUseCase;
  BatchUpdateUseCase batchUpdateUseCase;
  List<BaseItemEntity> baseItemList = [];
  final List<Request> _requestList = [];
  final List<int> _deleteListIndexes = [];
  final List<String> imageIdList = [];
  List<FormResponse> responseList = [];
  List<MoveItemEntity> moveItemList = [];
  List<ResponseEntity> responseEntityList = [];
  Request? formInfoUpdateRequest;
  bool isQuiz = false;
  int responseListSize = 0;
  int totalPoint = 0;

  String responderUrl = '';

  FormCubit(
    this.fetchFormUseCase,
    this.checkQuestionTypeUseCase,
    this.fetchFormResponsesUseCase,
    this.batchUpdateUseCase,
    this.fetchYoutubeListUseCase,
  ) : super(EditFormInitial());

  void addUploadedImageID(String id) {
    imageIdList.add(id);
  }

  Future<void> fetchForm(String formId) async {
    emit(FetchFormInitiatedState());
    await fetchResponses(formId);
    final response = await fetchFormUseCase(formId);
    if (response != null) {
      isQuiz = response.settings?.quizSettings?.isQuiz ?? false;
      final remoteItems = response.items;
      responderUrl = response.responderUri ?? '';
      if (remoteItems != null) {
        baseItemList.addAll(remoteItems.map((item) {
          _prepareResponseEntityList(item);
          return BaseItemEntity(
              itemId: item.itemId,
              item: item,
              opType: OperationType.update,
              request: null,
              key: ValueKey<String>(getRandomId()));
        }));
      }
      emit(ShowTitleState(
        response.info?.title ?? '',
        response.info?.description ?? '',
      ));
      emit(FormListUpdateState(baseItemList));
    } else {
      emit(FetchFormFailedState());
    }
  }

  Future<void> changeQuizSettings(bool toggle, String formId) async {
    emit(FetchFormInitiatedState());
    baseItemList.clear();
    final settingsRequest = Request(
        updateSettings: UpdateSettingsRequest(
            settings: FormSettings(
              quizSettings: QuizSettings(isQuiz: toggle),
            ),
            updateMask: Constants.quizSettings));
    await batchUpdateUseCase(
      BatchUpdateFormRequest(
          requests: [settingsRequest], includeFormInResponse: true),
      formId,
    );
    await fetchForm(formId);
  }

  Future<List<SearchResult>> fetchYoutubeList(String query) async {
    final searchListResponse = await fetchYoutubeListUseCase(query);
    return searchListResponse?.items ?? [];
  }

  void _prepareResponseEntityList(Item item) {
    responseList.sort((a, b) {
      return a.createTime!.compareTo(b.createTime!);
    });
    if (item.questionItem != null) {
      final List<String> answerList = [];

      int score = item.questionItem?.question?.grading?.pointValue ?? 0;

      totalPoint += score;

      for (var response in responseList) {
        response.answers?[item.questionItem!.question!.questionId!]?.textAnswers
            ?.answers
            ?.forEach((element) {
          answerList.add(element.value ?? '');
        });
      }
      responseEntityList.add(
        ResponseEntity(
          checkQuestionType(item),
          item.title ?? '',
          item.description ?? '',
          item,
          [
            QuestionAnswerEntity(
              item.questionItem!.question!.questionId!,
              answerList,
            )
          ],
        ),
      );
    }

    if (item.questionGroupItem != null) {
      final List<QuestionAnswerEntity> entityList = [];

      item.questionGroupItem?.questions?.forEach((question) {
        int score = question.grading?.pointValue ?? 0;

        totalPoint += score;
        final List<String> answerList = [];
        for (var response in responseList) {
          response.answers?[question.questionId!]?.textAnswers?.answers
              ?.forEach((element) {
            answerList.add(element.value ?? '');
          });
        }
        entityList.add(QuestionAnswerEntity(
          question.questionId!,
          answerList,
        ));
      });

      responseEntityList.add(
        ResponseEntity(
          checkQuestionType(item),
          item.title ?? '',
          item.description ?? '',
          item,
          entityList,
        ),
      );
    }
  }

  Future<void> fetchResponses(String formId) async {
    final response = await fetchFormResponsesUseCase(formId);
    responseListSize = response.length;
    responseList = response;
  }

  void addOtherRequest(Request request, int index) {
    baseItemList[index].request = request;
  }

  QuestionType checkQuestionType(Item? item) {
    return checkQuestionTypeUseCase(item);
  }

  void addItem(Item item, QuestionType type) {
    baseItemList.add(BaseItemEntity(
        item: item,
        opType: OperationType.create,
        request: CreateRequestItemHelper.prepareCreateRequest(
          type,
          baseItemList.length,
        ),
        key: ValueKey<String>(getRandomId())));
    emit(FormListUpdateState(baseItemList));
  }

  void replaceItem(int index, Item item, QuestionType questionType) {
    deleteItem(index);
    baseItemList.insert(
        index,
        BaseItemEntity(
            item: item,
            opType: OperationType.create,
            request: CreateRequestItemHelper.prepareCreateRequest(
              questionType,
              index,
            ),
            key: const ValueKey<String>('')));
    emit(FormListUpdateState(baseItemList));
  }

  void deleteItem(int index) async {
    if (baseItemList[index].itemId != null) {
      _deleteListIndexes.add(index);
    }
    baseItemList.removeAt(index);
    for (int i = 0; i < baseItemList.length; i++) {
      final element = baseItemList[i];
      if (element.request != null) {
        if (element.opType == OperationType.create) {
          element.request!.createItem!.location!.index = i;
        } else if (element.opType == OperationType.update) {
          element.request!.updateItem!.location!.index = i;
        }
      }
    }
    emit(FormListUpdateState(baseItemList));
  }

  void moveItem(int newIndex, int oldIndex) async {
    if (baseItemList[oldIndex].itemId != null) {
      moveItemList.add(MoveItemEntity(oldIndex, newIndex));
    }
    for (int i = 0; i < baseItemList.length; i++) {
      final element = baseItemList[i];
      if (element.request != null) {
        if (element.opType == OperationType.create) {
          element.request!.createItem!.location!.index = i;
        } else if (element.opType == OperationType.update) {
          element.request!.updateItem!.location!.index = i;
        }
      }
    }
  }

  Future<void> _onDeleteSuccess(String formId, bool fromShare) async {
    for (int index = 0; index < baseItemList.length; index++) {
      final value = baseItemList[index];

      if (value.request != null) {
        processGradingFeedbackRequest(value.request!);
        _requestList.add(value.request!);
      }
    }

    if (_requestList.isNotEmpty) {
      final isOtherRequestSubmitted = await batchUpdateUseCase(
        BatchUpdateFormRequest(
            requests: _requestList, includeFormInResponse: true),
        formId,
      );

      isOtherRequestSubmitted.fold((success) {
        emit(FormSubmitSuccessState(fromShare));
        prepareRequestInitialList();
      }, (error) {
        emit(FormSubmitFailedState(error.toString(), fromShare));
      });
    } else {
      if (_deleteListIndexes.isEmpty &&
          moveItemList.isEmpty &&
          formInfoUpdateRequest == null) {
        emit(FormSubmitFailedState(Constants.noChangesText, fromShare));
      } else {
        emit(FormSubmitSuccessState(fromShare));
      }
    }
  }

  Future<void> submitMoveRequest(String formId) async {
    List<Request> moveRequestList = [];
    for (var element in moveItemList) {
      moveRequestList.add(Request(
          moveItem: MoveItemRequest(
        newLocation: Location(index: element.newIndex),
        originalLocation: Location(index: element.oldIndex),
      )));
    }

    if (moveRequestList.isNotEmpty) {
      await batchUpdateUseCase(
        BatchUpdateFormRequest(
            requests: moveRequestList, includeFormInResponse: true),
        formId,
      );
    }
  }

  Future<void> submitFormInfoRequest(String formId) async {
    if (formInfoUpdateRequest != null) {
      await batchUpdateUseCase(
        BatchUpdateFormRequest(
            requests: [formInfoUpdateRequest!], includeFormInResponse: true),
        formId,
      );
    }
  }

  Future<void> submitRequest(String formId, {bool fromShare = false}) async {
    await submitMoveRequest(formId);
    await submitFormInfoRequest(formId);

    _deleteListIndexes.sort();
    List<Request> deleteRequestList = [];
    for (int i = 0; i < _deleteListIndexes.length; i++) {
      int index = 0;
      if (_deleteListIndexes[i] != 0) {
        index = _deleteListIndexes[i] - i;
      }
      deleteRequestList.add(DeleteRequestItemHelper.createDeleteRequest(index));
    }

    if (deleteRequestList.isNotEmpty) {
      final result = await batchUpdateUseCase(
        BatchUpdateFormRequest(
            requests: deleteRequestList, includeFormInResponse: true),
        formId,
      );

      await result.fold((success) async {
        await _onDeleteSuccess(formId, fromShare);
      }, (error) {
        emit(FormSubmitFailedState(error.toString(), fromShare));
      });
    } else {
      await _onDeleteSuccess(formId, fromShare);
    }
  }

  void prepareRequestInitialList() {
    moveItemList.clear();
    _deleteListIndexes.clear();
    _requestList.clear();
  }

  void deleteImagesFromDrive() async {
    final driveApi = await GoogleApisHelper.getDriveApi();
    if (driveApi != null) {
      for (var id in imageIdList) {
        if (id.isNotEmpty) {
          await driveApi.files.delete(id);
        }
      }
      imageIdList.clear();
    }
  }

  bool checkIfListIsEmpty() {
    for (int index = 0; index < baseItemList.length; index++) {
      final value = baseItemList[index];

      if (value.request != null) {
        return false;
      }
    }
    return true;
  }
}
