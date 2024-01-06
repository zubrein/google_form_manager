import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';

import 'create_question_item_helper.dart';

class UpdateRequestItemHelper {
  static Request prepareUpdateRequest(
      QuestionType questionType, int widgetIndex) {
    switch (questionType) {
      case QuestionType.shortAnswer:
        return prepareShortAnswerUpdateRequest(
          widgetIndex,
        );
      case QuestionType.paragraph:
        return prepareShortAnswerUpdateRequest(widgetIndex, isParagraph: true);
      case QuestionType.multipleChoice:
        return prepareMultipleChoiceUpdateRequest(widgetIndex,
            type: QuestionType.multipleChoice);
      case QuestionType.checkboxes:
        return prepareMultipleChoiceUpdateRequest(widgetIndex,
            type: QuestionType.checkboxes);
      case QuestionType.dropdown:
        return prepareMultipleChoiceUpdateRequest(widgetIndex,
            type: QuestionType.dropdown);
      case QuestionType.date:
        return prepareDateUpdateRequest(widgetIndex);
      case QuestionType.time:
        return prepareTimeUpdateRequest(widgetIndex);
      case QuestionType.linearScale:
        return prepareLinearScaleUpdateRequest(widgetIndex);
      case QuestionType.multipleChoiceGrid:
        return prepareMultipleChoiceGridUpdateRequest(widgetIndex,
            type: QuestionType.multipleChoiceGrid);
      case QuestionType.checkboxGrid:
        return prepareMultipleChoiceGridUpdateRequest(widgetIndex,
            type: QuestionType.checkboxGrid);
      case QuestionType.image:
        return prepareImageUpdateRequest(widgetIndex);
      case QuestionType.text:
        return prepareTextItemUpdateRequest(widgetIndex);
      case QuestionType.pageBreak:
        return preparePageBreakUpdateRequest(widgetIndex);
      default:
        return Request();
    }
  }

  static Request prepareShortAnswerUpdateRequest(
    int widgetIndex, {
    bool isParagraph = false,
  }) {
    return Request(
      updateItem: UpdateItemRequest(
          item: Item(
            title: '',
            description: '',
            questionItem: QuestionItem(
              question: Question(
                  grading: Grading(
                      pointValue: 0,
                      generalFeedback: Feedback(text: ''),
                      correctAnswers: CorrectAnswers(answers: [])),
                  textQuestion:
                      TextQuestion(paragraph: isParagraph ? true : null),
                  required: false),
            ),
          ),
          location: Location(index: widgetIndex),
          updateMask: ''),
    );
  }

  static Request prepareMultipleChoiceUpdateRequest(
    int widgetIndex, {
    required QuestionType type,
  }) {
    return Request(
      updateItem: UpdateItemRequest(
          item: Item(
            title: '',
            description: '',
            questionItem: QuestionItem(
              question: Question(
                  grading: Grading(
                      pointValue: 0,
                      whenRight: Feedback(text: ''),
                      whenWrong: Feedback(text: ''),
                      correctAnswers: CorrectAnswers(answers: [])),
                  choiceQuestion: ChoiceQuestion(
                    options: [Option(value: 'Option 1')],
                    shuffle: false,
                    type: CreateQuestionItemHelper.getTypeName(type),
                  ),
                  required: false),
            ),
          ),
          location: Location(index: widgetIndex),
          updateMask: ''),
    );
  }

  static Request prepareDateUpdateRequest(int widgetIndex) {
    return Request(
      updateItem: UpdateItemRequest(
          item: Item(
            title: '',
            description: '',
            questionItem: QuestionItem(
              question: Question(
                  grading: Grading(
                    pointValue: 0,
                    generalFeedback: Feedback(text: ''),
                  ),
                  dateQuestion: DateQuestion(
                    includeYear: true,
                    includeTime: false,
                  ),
                  required: false),
            ),
          ),
          location: Location(index: widgetIndex),
          updateMask: ''),
    );
  }

  static Request prepareTimeUpdateRequest(int widgetIndex) {
    return Request(
      updateItem: UpdateItemRequest(
          item: Item(
            title: '',
            description: '',
            questionItem: QuestionItem(
              question: Question(
                  grading: Grading(
                    pointValue: 0,
                    generalFeedback: Feedback(text: ''),
                  ),
                  timeQuestion: TimeQuestion(
                    duration: false,
                  ),
                  required: false),
            ),
          ),
          location: Location(index: widgetIndex),
          updateMask: ''),
    );
  }

  static Request prepareLinearScaleUpdateRequest(int widgetIndex) {
    return Request(
      updateItem: UpdateItemRequest(
          item: Item(
            title: '',
            description: '',
            questionItem: QuestionItem(
              question: Question(
                  grading: Grading(
                    pointValue: 0,
                    generalFeedback: Feedback(text: ''),
                  ),
                  scaleQuestion: ScaleQuestion(
                      low: 1, high: 5, lowLabel: '', highLabel: ''),
                  required: false),
            ),
          ),
          location: Location(index: widgetIndex),
          updateMask: ''),
    );
  }

  static Request prepareMultipleChoiceGridUpdateRequest(
    int widgetIndex, {
    required QuestionType type,
  }) {
    return Request(
      updateItem: UpdateItemRequest(
          item: Item(
            title: '',
            description: '',
            questionGroupItem: QuestionGroupItem(
                questions: [
                  Question(
                      grading: Grading(
                          pointValue: 0,
                          correctAnswers: CorrectAnswers(answers: [])),
                      rowQuestion: RowQuestion(title: 'Row 1'),
                      required: false)
                ],
                grid: Grid(
                    columns: ChoiceQuestion(
                  options: [Option(value: 'Column 1')],
                  type: CreateQuestionItemHelper.getTypeName(type),
                  shuffle: false,
                ))),
          ),
          location: Location(index: widgetIndex),
          updateMask: ''),
    );
  }

  static Request prepareImageUpdateRequest(int widgetIndex) {
    return Request(
        updateItem: UpdateItemRequest(
            item: (Item(
                title: '',
                imageItem: ImageItem(
                    image: Image(
                        contentUri: '',
                        properties: MediaProperties(
                          alignment: 'CENTER',
                          width: 1200,
                        ),
                        sourceUri: '')))),
            location: Location(index: widgetIndex),
            updateMask: ''));
  }

  static Request prepareTextItemUpdateRequest(int widgetIndex) {
    return Request(
        updateItem: UpdateItemRequest(
            item: (Item(title: '', description: '', textItem: TextItem())),
            location: Location(index: widgetIndex),
            updateMask: ''));
  }

  static Request preparePageBreakUpdateRequest(int widgetIndex) {
    return Request(
        updateItem: UpdateItemRequest(
            item: (Item(
                title: '', description: '', pageBreakItem: PageBreakItem())),
            location: Location(index: widgetIndex),
            updateMask: ''));
  }
}
