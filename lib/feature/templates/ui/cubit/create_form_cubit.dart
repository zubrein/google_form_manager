import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/usecases/batch_update_usecase.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:injectable/injectable.dart';

import '../../../google_form/edit_form/ui/widgets/helper/create_request_item_helper.dart';
import '../../domain/entities/template_entity.dart';
import '../../domain/usecases/create_form_usecase.dart';

part 'create_form_state.dart';

@injectable
class CreateFormCubit extends Cubit<CreateFormState> {
  CreateFormUseCase createFormUseCase;
  BatchUpdateUseCase batchUpdateUseCase;

  CreateFormCubit(
      {required this.createFormUseCase, required this.batchUpdateUseCase})
      : super(CreateFormInitial());

  Future<void> createForm(String formName, {bool isQuiz = false}) async {
    emit(CreateFormInitiatedState());
    final formId = await createFormUseCase(formName);
    final result = await batchUpdateUseCase(
        initialRequest(
          isQuiz: isQuiz,
        ),
        formId);

    result.fold((success) {
      emit(CreateFormSuccessState(formId));
    }, (error) {
      emit(CreateFormFailedState(error.toString()));
    });
  }

  Future<void> createTemplate(
    String formName,
    List<TemplateItemEntity> item, {
    BatchUpdateFormRequest? request,
  }) async {
    emit(CreateFormInitiatedState());
    final formId = await createFormUseCase(formName);
    final result = await batchUpdateUseCase(
      request ?? createTemplateRequests(item),
      formId,
    );

    result.fold((success) {
      emit(CreateFormSuccessState(formId));
    }, (error) {
      emit(CreateFormFailedState(error.toString()));
    });
  }

  BatchUpdateFormRequest initialRequest({bool isQuiz = false}) =>
      BatchUpdateFormRequest(
        requests: [
          Request(
            createItem: CreateItemRequest(
                item: Item(
                    questionItem: QuestionItem(
                        question: Question(
                            choiceQuestion: ChoiceQuestion(
                              options: [Option(value: 'Option 1')],
                              type: 'RADIO',
                              shuffle: false,
                            ),
                            required: false))),
                location: Location(index: 0)),
          ),
          Request(
              updateSettings: UpdateSettingsRequest(
            settings: FormSettings(
                quizSettings: QuizSettings(
              isQuiz: isQuiz,
            )),
            updateMask: 'quizSettings.isQuiz',
          ))
        ],
        includeFormInResponse: true,
      );

  BatchUpdateFormRequest createTemplateRequests(
      List<TemplateItemEntity> items) {
    List<Request> requests = [];

    for (var i = 0; i < items.length; i++) {
      requests.add(CreateRequestItemHelper.prepareCreateRequest(
          items[i].questionType, i,
          title: items[i].title));
    }

    return BatchUpdateFormRequest(requests: requests);
  }
}
