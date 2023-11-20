import 'package:google_form_manager/feature/edit_form/domain/enums.dart';

bool shouldShowButton(QuestionType questionType) {
  if (questionType == QuestionType.image) {
    return false;
  }
  return true;
}
