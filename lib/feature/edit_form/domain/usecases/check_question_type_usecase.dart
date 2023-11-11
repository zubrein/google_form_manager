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
    }

    return QuestionType.unknown;
  }
}
