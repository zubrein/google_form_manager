import 'package:google_form_manager/feature/edit_form/domain/enums.dart';

bool shouldShowButton(QuestionType questionType) {
  if (questionType == QuestionType.image || questionType == QuestionType.text) {
    return false;
  }
  return true;
}
