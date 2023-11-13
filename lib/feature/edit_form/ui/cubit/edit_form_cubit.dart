import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_form_manager/core/helper/logger.dart';
import 'package:google_form_manager/feature/edit_form/domain/entities/base_item_entity.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/batch_update_usecase.dart';
import '../../domain/usecases/check_question_type_usecase.dart';
import '../../domain/usecases/fetch_form_usecase.dart';
import '../widgets/helper/delete_request_item_helper.dart';

part 'edit_form_state.dart';

@injectable
class EditFormCubit extends Cubit<EditFormState> {
  FetchFormUseCase fetchFormUseCase;
  CheckQuestionTypeUseCase checkQuestionTypeUseCase;
  BatchUpdateUseCase batchUpdateUseCase;
  List<BaseItemEntity> baseItemList = [];
  final List<Request> _requestList = [];
  final List<int> _deleteListIndexes = [];

  EditFormCubit(
    this.fetchFormUseCase,
    this.checkQuestionTypeUseCase,
    this.batchUpdateUseCase,
  ) : super(EditFormInitial());

  Future<void> fetchForm(String formId) async {
    emit(FetchFormInitiatedState());
    final response = await fetchFormUseCase(formId);
    if (response != null) {
      final remoteItems = response.items;
      if (remoteItems != null) {
        baseItemList.addAll(remoteItems.map((item) {
          return BaseItemEntity(
            item: item,
            opType: OperationType.update,
            visibility: true,
            request: null,
          );
        }));
      }
      emit(FormListUpdateState(baseItemList));
    } else {
      emit(FetchFormFailedState());
    }
  }

  void addOtherRequest(Request request, int index) {
    baseItemList[index].request = request;
    printRequest(request, index);
  }

  QuestionType checkQuestionType(Item? item) {
    return checkQuestionTypeUseCase(item);
  }

  void addItem(Item item) {
    baseItemList.add(BaseItemEntity(
      item: item,
      opType: OperationType.create,
      visibility: true,
      request: null,
    ));
    emit(FormListUpdateState(baseItemList));
  }

  void deleteItem(int index) async {
    baseItemList[index].visibility = false;
    emit(FormListUpdateState(baseItemList));
  }

  printRequest(Request request, int index) {
    Log.info('''
        index : $index
        update Mask : ${request.updateItem?.updateMask}
        title : ${request.updateItem?.item?.title}
        description : ${request.updateItem?.item?.description}
        required: ${request.updateItem?.item?.questionItem?.question?.required}
        ''');
  }

  Future<bool> submitForm(String formId) async {
    for (int index = 0; index < baseItemList.length; index++) {
      final value = baseItemList[index];

      if (value.visibility == true) {
        if (value.request != null) {
          _requestList.add(value.request!);
        }
      } else if (value.visibility == false) {
        _deleteListIndexes.add(index);
      }
    }

    if (_requestList.isNotEmpty) {
      final isOtherRequestSubmitted = await batchUpdateUseCase(
        BatchUpdateFormRequest(
            requests: _requestList, includeFormInResponse: true),
        formId,
      );

      if (isOtherRequestSubmitted) {
        return await submitDeleteRequest(formId);
      } else {
        return false;
      }
    } else {
      final isDeleteRequestSubmitted = await submitDeleteRequest(formId);
      return isDeleteRequestSubmitted ? true : false;
    }
  }

  Future<bool> submitDeleteRequest(String formId) async {
    Log.info('delete list length: ${_deleteListIndexes.length}');
    _deleteListIndexes.sort();
    List<Request> deleteRequestList = [];
    for (int i = 0; i < _deleteListIndexes.length; i++) {
      deleteRequestList.add(DeleteRequestItemHelper.createDeleteRequest(
          _deleteListIndexes[i] - i));
    }

    if (deleteRequestList.isNotEmpty) {
      final isSubmitted = await batchUpdateUseCase(
        BatchUpdateFormRequest(
            requests: deleteRequestList, includeFormInResponse: true),
        formId,
      );
      prepareRequestInitialList();
      return isSubmitted ? true : false;
    } else {
      return true;
    }
  }

  void prepareRequestInitialList() {
    _deleteListIndexes.clear();
    _requestList.clear();
  }
}
