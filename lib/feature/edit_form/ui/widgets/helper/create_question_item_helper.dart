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
      case QuestionType.date:
        return getDateItem();
      case QuestionType.time:
        return getTimeItem();
      case QuestionType.linearScale:
        return getLinearScaleItem();
      case QuestionType.multipleChoiceGrid:
        return getMultipleChoiceGridItem(QuestionType.multipleChoiceGrid);
      case QuestionType.checkboxGrid:
        return getMultipleChoiceGridItem(QuestionType.checkboxGrid);
      case QuestionType.image:
        return getImageItem();
      case QuestionType.text:
        return getTextItem();

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
                  options: [Option(value: 'Option 1')],
                  type: getTypeName(type),
                  shuffle: false,
                ),
                required: false)));
  }

  static Item getDateItem() {
    return Item(
        questionItem: QuestionItem(
            question: Question(
                dateQuestion:
                    DateQuestion(includeTime: false, includeYear: true),
                required: false)));
  }

  static Item getTimeItem() {
    return Item(
        questionItem: QuestionItem(
            question: Question(
                timeQuestion: TimeQuestion(
                  duration: false,
                ),
                required: false)));
  }

  static Item getLinearScaleItem() {
    return Item(
        questionItem: QuestionItem(
            question: Question(
                scaleQuestion: ScaleQuestion(
                  low: 1,
                  high: 5,
                  lowLabel: '',
                  highLabel: '',
                ),
                required: false)));
  }

  static Item getMultipleChoiceGridItem(QuestionType type) {
    return Item(
        questionGroupItem: QuestionGroupItem(
            questions: [
          Question(
            rowQuestion: RowQuestion(title: 'Row 1'),
          )
        ],
            grid: Grid(
                columns: ChoiceQuestion(
              options: [Option(value: 'Column 1')],
              type: getTypeName(type),
              shuffle: false,
            ))));
  }

  static Item getImageItem() {
    return Item(title: '', imageItem: ImageItem(image: Image(sourceUri: '')));
  }

  static Item getTextItem() {
    return Item(title: '', description: '', textItem: TextItem());
  }

  static String getTypeName(QuestionType type) {
    if (type == QuestionType.multipleChoice ||
        type == QuestionType.multipleChoiceGrid) return 'RADIO';
    if (type == QuestionType.checkboxes || type == QuestionType.checkboxGrid) {
      return 'CHECKBOX';
    }
    if (type == QuestionType.dropdown) return 'DROP_DOWN';

    return '';
  }
}
