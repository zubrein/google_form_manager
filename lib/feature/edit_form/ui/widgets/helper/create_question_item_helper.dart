import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';

class CreateQuestionItemHelper {
  static Item getItem(QuestionType questionType) {
    switch (questionType) {
      case QuestionType.shortAnswer:
        return getShortAnswerItem();
      case QuestionType.paragraph:
        return getShortAnswerItem(isParagraph: true);
      case QuestionType.multipleChoice:
        return getMultipleChoiceItem(QuestionType.multipleChoice);
      case QuestionType.checkboxes:
        return getMultipleChoiceItem(QuestionType.checkboxes);
      case QuestionType.dropdown:
        return getMultipleChoiceItem(QuestionType.dropdown);
      default:
        return Item();
    }
  }

  static Item getShortAnswerItem({bool? isParagraph}) {
    return Item(
        questionItem: QuestionItem(
            question: Question(
                textQuestion: TextQuestion(paragraph: isParagraph),
                required: false)));
  }

  static Item getMultipleChoiceItem(QuestionType type) {
    return Item(
        questionItem: QuestionItem(
            question: Question(
                choiceQuestion: ChoiceQuestion(
                  options: [Option(value: 'Option')],
                  type: getTypeName(type),
                  shuffle: false,
                ),
                required: false)));
  }

  static String getTypeName(QuestionType type) {
    if (type == QuestionType.multipleChoice) return 'RADIO';
    if (type == QuestionType.checkboxes) return 'CHECKBOX';
    if (type == QuestionType.dropdown) return 'DROP_DOWN';

    return '';
  }
}
