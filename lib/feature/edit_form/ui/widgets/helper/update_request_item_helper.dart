import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/helper/create_question_item_helper.dart';
import 'package:googleapis/forms/v1.dart';

class UpdateRequestItemHelper {
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
      case QuestionType.date:
        return UpdateRequestItemHelper.prepareDateUpdateRequest(widgetIndex);

      default:
        return Request();
    }
  }

  static Request prepareShortAnswerUpdateRequest(
    int widgetIndex, {
    bool isParagraph = false,
  }) {
    return Request(
      updateItem: UpdateItemRequest(
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
          updateMask: ''),
    );
  }

  static Request prepareMultipleChoiceUpdateRequest(
    int widgetIndex, {
    required QuestionType type,
  }) {
    return Request(
      updateItem: UpdateItemRequest(
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
          updateMask: ''),
    );
  }

  static Request prepareDateUpdateRequest(int widgetIndex) {
    return Request(
      updateItem: UpdateItemRequest(
          item: Item(
            title: '',
            description: '',
            questionItem: QuestionItem(
              question: Question(
                  dateQuestion: DateQuestion(
                    includeYear: true,
                    includeTime: false,
                  ),
                  required: false),
            ),
          ),
          location: Location(index: widgetIndex),
          updateMask: ''),
    );
  }

  static Request prepareTimeUpdateRequest(int widgetIndex) {
    return Request(
      updateItem: UpdateItemRequest(
          item: Item(
            title: '',
            description: '',
            questionItem: QuestionItem(
              question: Question(
                  timeQuestion: TimeQuestion(
                    duration: false,
                  ),
                  required: false),
            ),
          ),
          location: Location(index: widgetIndex),
          updateMask: ''),
    );
  }
}
