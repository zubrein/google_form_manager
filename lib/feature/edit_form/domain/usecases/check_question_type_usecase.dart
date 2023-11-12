import 'package:injectable/injectable.dart';

import '../enums.dart';
import 'package:googleapis/forms/v1.dart';

@injectable
class CheckQuestionTypeUseCase {
  CheckQuestionTypeUseCase();

  QuestionType call(Item? item) {
    if (item?.questionItem?.question?.textQuestion != null &&
        item?.questionItem?.question?.textQuestion?.paragraph == null) {
      return QuestionType.shortAnswer;
    } else if (item?.questionItem?.question?.textQuestion?.paragraph != null &&
        item?.questionItem?.question?.textQuestion?.paragraph == true) {
      return QuestionType.paragraph;
    } else if (item?.questionItem?.question?.choiceQuestion != null &&
        item?.questionItem?.question?.choiceQuestion?.type == 'RADIO') {
      return QuestionType.multipleChoice;
    } else if (item?.questionItem?.question?.choiceQuestion != null &&
        item?.questionItem?.question?.choiceQuestion?.type == 'CHECKBOX') {
      return QuestionType.checkboxes;
    } else if (item?.questionItem?.question?.choiceQuestion != null &&
        item?.questionItem?.question?.choiceQuestion?.type == 'DROP_DOWN') {
      return QuestionType.dropdown;
    }

    return QuestionType.unknown;
  }
}
