import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_form_manager/core/helper/logger.dart';
import 'package:google_form_manager/feature/edit_form/domain/entities/base_item_entity.dart';
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
  List<BaseItemEntity> baseItemList = [];

  EditFormCubit(
    this.fetchFormUseCase,
    this.checkQuestionTypeUseCase,
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
          );
        }));
      }
      emit(FormListUpdateState(baseItemList));
    } else {
      emit(FetchFormFailedState());
    }
  }

  QuestionType checkQuestionType(Item? item) {
    return checkQuestionTypeUseCase(item);
  }

  void addItem(Item item) {
    baseItemList.add(BaseItemEntity(
        item: item, opType: OperationType.create, visibility: true));
    emit(FormListUpdateState(baseItemList));
  }

  void deleteItem(int index) async {
    Log.info(index.toString());
    baseItemList[index].visibility = false;
    emit(FormListUpdateState(baseItemList));
  }
}
