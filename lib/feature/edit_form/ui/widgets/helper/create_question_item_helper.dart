import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';

class CreateQuestionItemHelper {
  static Item getItem(QuestionType questionType) {
    switch (questionType) {
      case QuestionType.shortAnswer:
        return getShortAnswerItem();
      case QuestionType.paragraph:
        return getShortAnswerItem(isParagraph: true);
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
}
