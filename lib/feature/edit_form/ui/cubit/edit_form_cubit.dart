import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_form_manager/feature/edit_form/domain/usecases/batch_update_usecase.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/fetch_form_usecase.dart';

part 'edit_form_state.dart';

@injectable
class EditFormCubit extends Cubit<EditFormState> {
  FetchFormUseCase fetchFormUseCase;
  BatchUpdateUseCase editFormUsCase;

  EditFormCubit(
    this.fetchFormUseCase,
    this.editFormUsCase,
  ) : super(EditFormInitial());

  Future<void> fetchForm(String formId) async {
    emit(FetchFormInitiatedState());
    final response = await fetchFormUseCase(formId);
    if (response != null) {
      emit(FetchFormSuccessState(response));
    } else {
      emit(FetchFormFailedState());
    }
  }
}
