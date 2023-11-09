import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/check_question_type_usecase.dart';
import '../../domain/usecases/fetch_form_usecase.dart';

part 'edit_form_state.dart';

@injectable
class EditFormCubit extends Cubit<EditFormState> {
  FetchFormUseCase fetchFormUseCase;
  CheckQuestionTypeUseCase checkQuestionTypeUseCase;
  List<Item> items = [];

  EditFormCubit(
    this.fetchFormUseCase,
    this.checkQuestionTypeUseCase,
  ) : super(EditFormInitial());

  Future<void> fetchForm(String formId) async {
    emit(FetchFormInitiatedState());
    final response = await fetchFormUseCase(formId);
    if (response != null) {
      items.addAll(response.items ?? []);
      emit(FormListUpdateState(items));
    } else {
      emit(FetchFormFailedState());
    }
  }

  QuestionType checkQuestionType(Item? item) {
    return checkQuestionTypeUseCase(item);
  }

  void addItem(Item item) {
    items.add(item);
    emit(FormListUpdateState(items));
  }

  void deleteItem(int index) {
    items.removeAt(index);
    emit(FormListUpdateState(items));
  }
}
