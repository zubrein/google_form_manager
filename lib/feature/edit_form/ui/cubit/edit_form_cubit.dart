import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_form_manager/core/helper/logger.dart';
import 'package:google_form_manager/feature/edit_form/domain/entities/base_item_entity.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/helper/create_request_item_helper.dart';
import 'package:google_form_manager/util/utility.dart';
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
  final List<String> imageIdList = [];

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
              itemId: item.itemId,
              item: item,
              opType: OperationType.update,
              request: null,
              key: ValueKey<String>(getRandomId()));
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

  printRequest(Request request, int index) {
    Log.info('''
        index : $index
        update Mask : ${request.updateItem?.updateMask}
        title : ${request.updateItem?.item?.title}
        description : ${request.updateItem?.item?.description}
        required: ${request.updateItem?.item?.questionItem?.question?.required}
        ''');
  }

  Future<void> _onDeleteSuccess(String formId) async {
    for (int index = 0; index < baseItemList.length; index++) {
      final value = baseItemList[index];

      if (value.request != null) {
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
        emit(const FormSubmitSuccessState());
        prepareRequestInitialList();
      }, (error) {
        emit(FormSubmitFailedState(error.toString()));
      });
    } else {
      Log.info('No list');
      if(_deleteListIndexes.isEmpty) {
        emit(FormSubmitFailedState('No changes done yet'));
      }else{
        emit(const FormSubmitSuccessState());
      }
    }
  }

  Future<void> submitRequest(String formId) async {
    _deleteListIndexes.sort();
    List<Request> deleteRequestList = [];
    for (int i = 0; i < _deleteListIndexes.length; i++) {
      deleteRequestList.add(DeleteRequestItemHelper.createDeleteRequest(
          _deleteListIndexes[i] - i));
    }

    if (deleteRequestList.isNotEmpty) {
      final result = await batchUpdateUseCase(
        BatchUpdateFormRequest(
            requests: deleteRequestList, includeFormInResponse: true),
        formId,
      );

      await result.fold((success) async {
        await _onDeleteSuccess(formId);
      }, (error) {
        emit(FormSubmitFailedState(error.toString()));
      });
    } else {
      await _onDeleteSuccess(formId);
    }
  }

  void prepareRequestInitialList() {
    _deleteListIndexes.clear();
    _requestList.clear();
  }
}
