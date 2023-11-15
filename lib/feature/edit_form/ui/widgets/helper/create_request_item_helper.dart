import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/helper/create_question_item_helper.dart';
import 'package:googleapis/forms/v1.dart';

import 'update_request_item_helper.dart';

class CreateRequestItemHelper {
  static Request prepareInitialRequest({
    required OperationType operationType,
    required QuestionType questionType,
    required int index,
  }) {
    switch (operationType) {
      case OperationType.update:
        return prepareUpdateRequest(questionType, index);
      case OperationType.create:
        return prepareCreateRequest(questionType, index);
      default:
        return Request();
    }
  }

  static Request prepareUpdateRequest(
      QuestionType questionType, int widgetIndex) {
    switch (questionType) {
      case QuestionType.shortAnswer:
        return UpdateRequestItemHelper.prepareShortAnswerUpdateRequest(
          widgetIndex,
        );
      case QuestionType.paragraph:
        return UpdateRequestItemHelper.prepareShortAnswerUpdateRequest(
            widgetIndex,
            isParagraph: true);
      case QuestionType.multipleChoice:
        return UpdateRequestItemHelper.prepareMultipleChoiceUpdateRequest(
            widgetIndex,
            type: QuestionType.multipleChoice);
      case QuestionType.checkboxes:
        return UpdateRequestItemHelper.prepareMultipleChoiceUpdateRequest(
            widgetIndex,
            type: QuestionType.checkboxes);
      case QuestionType.dropdown:
        return UpdateRequestItemHelper.prepareMultipleChoiceUpdateRequest(
            widgetIndex,
            type: QuestionType.dropdown);

      default:
        return Request();
    }
  }

  static Request prepareCreateRequest(
      QuestionType questionType, int widgetIndex) {
    switch (questionType) {
      case QuestionType.shortAnswer:
        return CreateRequestItemHelper.prepareShortAnswerCreateRequest(
          widgetIndex,
        );
      case QuestionType.paragraph:
        return CreateRequestItemHelper.prepareShortAnswerCreateRequest(
            widgetIndex,
            isParagraph: true);
      case QuestionType.multipleChoice:
        return CreateRequestItemHelper.prepareMultipleChoiceCreateRequest(
            widgetIndex,
            type: QuestionType.multipleChoice);
      case QuestionType.checkboxes:
        return CreateRequestItemHelper.prepareMultipleChoiceCreateRequest(
            widgetIndex,
            type: QuestionType.checkboxes);
      case QuestionType.dropdown:
        return CreateRequestItemHelper.prepareMultipleChoiceCreateRequest(
            widgetIndex,
            type: QuestionType.dropdown);

      default:
        return Request();
    }
  }

  static Request prepareShortAnswerCreateRequest(
      int widgetIndex, {
        bool isParagraph = false,
      }) {
    return Request(
      createItem: CreateItemRequest(
        item: Item(
          title: '',
          description: '',
          questionItem: QuestionItem(
            question: Question(
                textQuestion:
                TextQuestion(paragraph: isParagraph ? true : null),
                required: false),
          ),
        ),
        location: Location(index: widgetIndex),
      ),
    );
  }

  static Request prepareMultipleChoiceCreateRequest(int widgetIndex,
      {required QuestionType type}) {
    return Request(
      createItem: CreateItemRequest(
        item: Item(
          title: '',
          description: '',
          questionItem: QuestionItem(
            question: Question(
                choiceQuestion: ChoiceQuestion(
                  options: [Option(value: 'Option 1')],
                  shuffle: false,
                  type: CreateQuestionItemHelper.getTypeName(type),
                ),
                required: false),
          ),
        ),
        location: Location(index: widgetIndex),
      ),
    );
  }
}
