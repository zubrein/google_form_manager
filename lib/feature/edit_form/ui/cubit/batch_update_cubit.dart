import 'package:bloc/bloc.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:injectable/injectable.dart';

import 'edit_form_cubit.dart';

@singleton
class BatchUpdateCubit extends Cubit<EditFormState> {
  BatchUpdateCubit() : super(EditFormInitial());

  BatchUpdateFormRequest batchUpdateFormRequest = BatchUpdateFormRequest();
  final List<Request> _request = [];

  void addRequest(Request request) {
    _request.add(request);
  }

  void deleteRequest(int index) {
    _request.removeAt(index);
  }

  void updateRequest(Request request, int index) {
    _request[index] = request;
  }
}
