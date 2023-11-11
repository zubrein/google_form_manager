import 'package:bloc/bloc.dart';
import 'package:google_form_manager/core/helper/logger.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/helper/delete_request_item_helper.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/batch_update_usecase.dart';
import 'edit_form_cubit.dart';

@singleton
class BatchUpdateCubit extends Cubit<EditFormState> {
  BatchUpdateUseCase batchUpdateUseCase;

  BatchUpdateCubit(this.batchUpdateUseCase) : super(EditFormInitial());

  BatchUpdateFormRequest batchUpdateFormRequest = BatchUpdateFormRequest();
  final List<Request?> _otherRequests = [];
  final List<int> _deleteRequestsIndex = [];
  final List<Request> _finalRequests = [];

  void addOtherRequest(Request request, int index) {
    _otherRequests.removeAt(index);
    _otherRequests.insert(index, request);
    printRequest(request, index);
  }

  void addDeleteRequest(int index) {
    Log.info(index.toString());
    _deleteRequestsIndex.add(index);
  }

  Future<bool> submitForm(String formId) async {
    for (var value in _otherRequests) {
      if (value != null) {
        _finalRequests.add(value);
      }
    }

    if (_finalRequests.isNotEmpty) {
      final isOtherRequestSubmitted = await batchUpdateUseCase(
        BatchUpdateFormRequest(
            requests: _finalRequests, includeFormInResponse: true),
        formId,
      );

      if (isOtherRequestSubmitted) {
        final isDeleteRequestSubmitted = await submitDeleteRequest(formId);
        prepareRequestInitialList();
        _finalRequests.clear();
        return isDeleteRequestSubmitted ? true : false;
      } else {
        return false;
      }
    } else {
      final isDeleteRequestSubmitted = await submitDeleteRequest(formId);
      prepareRequestInitialList();
      _finalRequests.clear();
      return isDeleteRequestSubmitted ? true : false;
    }
  }

  Future<bool> submitDeleteRequest(String formId) async {
    _deleteRequestsIndex.sort();
    List<Request> deleteRequestList = [];
    for (int i = 0; i < _deleteRequestsIndex.length; i++) {
      deleteRequestList.add(DeleteRequestItemHelper.createDeleteRequest(
          _deleteRequestsIndex[i] - i));
    }

    if (deleteRequestList.isNotEmpty) {
      final isSubmitted = await batchUpdateUseCase(
        BatchUpdateFormRequest(
            requests: deleteRequestList, includeFormInResponse: true),
        formId,
      );

      if (isSubmitted) {
        _deleteRequestsIndex.clear();
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  void prepareRequestInitialList() {
    _deleteRequestsIndex.clear();
    _otherRequests.clear();
    _otherRequests.addAll(List<Request?>.filled(200, null));
  }
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
