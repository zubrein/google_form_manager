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
    } else if (item?.questionItem?.question?.dateQuestion != null) {
      return QuestionType.date;
    } else if (item?.questionItem?.question?.timeQuestion != null) {
      return QuestionType.time;
    } else if (item?.questionItem?.question?.scaleQuestion != null) {
      return QuestionType.linearScale;
    } else if (item?.questionGroupItem?.questions != null &&
        item?.questionGroupItem?.grid?.columns?.type == 'RADIO') {
      return QuestionType.multipleChoiceGrid;
    } else if (item?.questionGroupItem?.questions != null &&
        item?.questionGroupItem?.grid?.columns?.type == 'CHECKBOX') {
      return QuestionType.checkboxGrid;
    } else if (item?.imageItem?.image != null) {
      return QuestionType.image;
    } else if (item?.textItem != null) {
      return QuestionType.text;
    } else if (item?.pageBreakItem != null) {
      return QuestionType.pageBreak;
    }

    return QuestionType.unknown;
  }
}
