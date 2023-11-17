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
      case QuestionType.time:
        return UpdateRequestItemHelper.prepareTimeUpdateRequest(widgetIndex);
      case QuestionType.linearScale:
        return UpdateRequestItemHelper.prepareLinearScaleUpdateRequest(
            widgetIndex);
      case QuestionType.multipleChoiceGrid:
        return UpdateRequestItemHelper.prepareMultipleChoiceGridUpdateRequest(
            widgetIndex,
            type: QuestionType.multipleChoiceGrid);
      case QuestionType.checkboxGrid:
        return UpdateRequestItemHelper.prepareMultipleChoiceGridUpdateRequest(
            widgetIndex,
            type: QuestionType.checkboxGrid);
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

  static Request prepareLinearScaleUpdateRequest(int widgetIndex) {
    return Request(
      updateItem: UpdateItemRequest(
          item: Item(
            title: '',
            description: '',
            questionItem: QuestionItem(
              question: Question(
                  scaleQuestion: ScaleQuestion(
                      low: 1, high: 5, lowLabel: '', highLabel: ''),
                  required: false),
            ),
          ),
          location: Location(index: widgetIndex),
          updateMask: ''),
    );
  }

  static Request prepareMultipleChoiceGridUpdateRequest(
    int widgetIndex, {
    required QuestionType type,
  }) {
    return Request(
      updateItem: UpdateItemRequest(
          item: Item(
            title: '',
            description: '',
            questionGroupItem: QuestionGroupItem(
                questions: [
                  Question(
                      rowQuestion: RowQuestion(title: 'Row 1'), required: false)
                ],
                grid: Grid(
                    columns: ChoiceQuestion(
                  options: [Option(value: 'Column 1')],
                  type: CreateQuestionItemHelper.getTypeName(type),
                  shuffle: false,
                ))),
          ),
          location: Location(index: widgetIndex),
          updateMask: ''),
    );
  }
}
