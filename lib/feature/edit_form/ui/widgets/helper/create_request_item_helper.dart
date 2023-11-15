import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/helper/create_question_item_helper.dart';
import 'package:googleapis/forms/v1.dart';

class CreateRequestItemHelper {
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
      case QuestionType.date:
        return CreateRequestItemHelper.prepareDateCreateRequest(widgetIndex);
      case QuestionType.time:
        return CreateRequestItemHelper.prepareTimeCreateRequest(widgetIndex);
      case QuestionType.linearScale:
        return CreateRequestItemHelper.prepareLinearScaleCreateRequest(
            widgetIndex);

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

  static Request prepareDateCreateRequest(int widgetIndex) {
    return Request(
      createItem: CreateItemRequest(
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
      ),
    );
  }

  static Request prepareTimeCreateRequest(int widgetIndex) {
    return Request(
      createItem: CreateItemRequest(
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
      ),
    );
  }

  static Request prepareLinearScaleCreateRequest(int widgetIndex) {
    return Request(
      createItem: CreateItemRequest(
        item: Item(
          title: '',
          description: '',
          questionItem: QuestionItem(
            question: Question(
                scaleQuestion:
                    ScaleQuestion(low: 1, high: 5, lowLabel: '', highLabel: ''),
                required: false),
          ),
        ),
        location: Location(index: widgetIndex),
      ),
    );
  }
}
