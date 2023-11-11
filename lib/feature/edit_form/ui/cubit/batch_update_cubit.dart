import 'package:bloc/bloc.dart';
import 'package:google_form_manager/core/helper/logger.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/batch_update_usecase.dart';
import 'edit_form_cubit.dart';

@singleton
class BatchUpdateCubit extends Cubit<EditFormState> {
  BatchUpdateUseCase batchUpdateUseCase;

  BatchUpdateCubit(this.batchUpdateUseCase) : super(EditFormInitial());

  BatchUpdateFormRequest batchUpdateFormRequest = BatchUpdateFormRequest();
  final List<Request?> _request = [];
  final List<Request> _finalRequest = [];

  void addRequest(Request request, int index) {
    _request.removeAt(index);
    _request.insert(index, request);

    Log.info('''
        index : $index
        update Mask : ${_request[index]?.updateItem?.updateMask}
        title : ${_request[index]?.updateItem?.item?.title}
        description : ${_request[index]?.updateItem?.item?.description}
        required: ${_request[index]?.updateItem?.item?.questionItem?.question?.required}
        ''');
  }

  Future<bool> submitForm(String formId) async {
    for (var value in _request) {
      if (value != null) {
        printRequest(value);
        _finalRequest.add(value);
      }
    }
    Log.info(_finalRequest.length.toString());
    final isSubmitted = await batchUpdateUseCase(
      BatchUpdateFormRequest(
          requests: _finalRequest, includeFormInResponse: true),
      formId,
    );
    if (isSubmitted) {
      prepareRequestInitialList();
      _finalRequest.clear();
      return true;
    } else {
      return false;
    }
  }

  void prepareRequestInitialList() {
    _request.clear();
    _request.addAll(List<Request?>.filled(200, null));
  }
}

printRequest(Request request) {
  Log.info('''
    {
      "deleteItem": {
        "location": {
          "index": ${request.deleteItem?.location?.index}
        }
      }
    } 
  ''');
}
