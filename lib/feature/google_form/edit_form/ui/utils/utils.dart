import '../../domain/enums.dart';

bool shouldShowButton(QuestionType questionType) {
  if (questionType == QuestionType.image ||
      questionType == QuestionType.text ||
      questionType == QuestionType.pageBreak) {
    return false;
  }
  return true;
}
