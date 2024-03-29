import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';

import 'create_question_item_helper.dart';

class CreateRequestItemHelper {
  static Request prepareCreateRequest(
    QuestionType questionType,
    int widgetIndex, {
    String title = '',
  }) {
    switch (questionType) {
      case QuestionType.shortAnswer:
        return prepareShortAnswerCreateRequest(
          widgetIndex,
          title: title,
        );
      case QuestionType.paragraph:
        return prepareShortAnswerCreateRequest(
          widgetIndex,
          isParagraph: true,
          title: title,
        );
      case QuestionType.multipleChoice:
        return prepareMultipleChoiceCreateRequest(
          widgetIndex,
          type: QuestionType.multipleChoice,
          title: title,
        );
      case QuestionType.checkboxes:
        return prepareMultipleChoiceCreateRequest(
          widgetIndex,
          type: QuestionType.checkboxes,
          title: title,
        );
      case QuestionType.dropdown:
        return prepareMultipleChoiceCreateRequest(
          widgetIndex,
          type: QuestionType.dropdown,
          title: title,
        );
      case QuestionType.date:
        return prepareDateCreateRequest(
          widgetIndex,
          title: title,
        );
      case QuestionType.time:
        return prepareTimeCreateRequest(
          widgetIndex,
          title: title,
        );
      case QuestionType.linearScale:
        return prepareLinearScaleCreateRequest(
          widgetIndex,
          title: title,
        );
      case QuestionType.multipleChoiceGrid:
        return prepareMultipleChoiceGridCreateRequest(
          widgetIndex,
          type: QuestionType.multipleChoiceGrid,
          title: title,
        );
      case QuestionType.checkboxGrid:
        return prepareMultipleChoiceGridCreateRequest(
          widgetIndex,
          type: QuestionType.checkboxGrid,
          title: title,
        );
      case QuestionType.image:
        return prepareImageCreateRequest(widgetIndex);
      case QuestionType.text:
        return prepareTextItemCreateRequest(widgetIndex);
      case QuestionType.pageBreak:
        return preparePageBreakCreateRequest(widgetIndex);
      case QuestionType.video:
        return prepareVideoCreateRequest(widgetIndex);

      default:
        return Request();
    }
  }

  static Request prepareCreateRequestWithGrading(
      QuestionType questionType, int widgetIndex) {
    switch (questionType) {
      case QuestionType.shortAnswer:
        return prepareShortAnswerCreateRequestWithGrading(
          widgetIndex,
        );
      case QuestionType.paragraph:
        return prepareShortAnswerCreateRequestWithGrading(widgetIndex,
            isParagraph: true);
      case QuestionType.multipleChoice:
        return prepareMultipleChoiceCreateRequestWithGrading(widgetIndex,
            type: QuestionType.multipleChoice);
      case QuestionType.checkboxes:
        return prepareMultipleChoiceCreateRequestWithGrading(widgetIndex,
            type: QuestionType.checkboxes);
      case QuestionType.dropdown:
        return prepareMultipleChoiceCreateRequestWithGrading(widgetIndex,
            type: QuestionType.dropdown);
      case QuestionType.date:
        return prepareDateCreateRequestWithGrading(widgetIndex);
      case QuestionType.time:
        return prepareTimeCreateRequestWithGrading(widgetIndex);
      case QuestionType.linearScale:
        return prepareLinearScaleCreateRequestWithGrading(widgetIndex);
      case QuestionType.multipleChoiceGrid:
        return prepareMultipleChoiceGridCreateRequestWithGrading(widgetIndex,
            type: QuestionType.multipleChoiceGrid);
      case QuestionType.checkboxGrid:
        return prepareMultipleChoiceGridCreateRequestWithGrading(widgetIndex,
            type: QuestionType.checkboxGrid);
      case QuestionType.image:
        return prepareImageCreateRequest(widgetIndex);
      case QuestionType.text:
        return prepareTextItemCreateRequest(widgetIndex);
      case QuestionType.pageBreak:
        return preparePageBreakCreateRequest(widgetIndex);
      case QuestionType.video:
        return prepareVideoCreateRequest(widgetIndex);

      default:
        return Request();
    }
  }

  static Request prepareShortAnswerCreateRequest(
    int widgetIndex, {
    bool isParagraph = false,
    String title = '',
  }) {
    return Request(
      createItem: CreateItemRequest(
        item: Item(
          title: title,
          description: '',
          questionItem: QuestionItem(
            question: Question(
                textQuestion:
                    TextQuestion(paragraph: isParagraph ? true : null),
                required: false),
          ),
        ),
        location: Location(index: widgetIndex),
      ),
    );
  }

  static Request prepareShortAnswerCreateRequestWithGrading(
    int widgetIndex, {
    bool isParagraph = false,
  }) {
    return Request(
      createItem: CreateItemRequest(
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
      ),
    );
  }

  static Request prepareMultipleChoiceCreateRequest(
    int widgetIndex, {
    required QuestionType type,
    String title = '',
  }) {
    return Request(
      createItem: CreateItemRequest(
        item: Item(
          title: title,
          description: '',
          questionItem: QuestionItem(
            question: Question(
                choiceQuestion: ChoiceQuestion(
                  options: [Option(value: 'Option 1')],
                  shuffle: false,
                  type: CreateQuestionItemHelper.getTypeName(type),
                ),
                required: false),
          ),
        ),
        location: Location(index: widgetIndex),
      ),
    );
  }

  static Request prepareMultipleChoiceCreateRequestWithGrading(int widgetIndex,
      {required QuestionType type}) {
    return Request(
      createItem: CreateItemRequest(
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
      ),
    );
  }

  static Request prepareDateCreateRequest(
    int widgetIndex, {
    String title = '',
  }) {
    return Request(
      createItem: CreateItemRequest(
        item: Item(
          title: title,
          description: '',
          questionItem: QuestionItem(
            question: Question(
                dateQuestion: DateQuestion(
                  includeYear: true,
                  includeTime: false,
                ),
                required: false),
          ),
        ),
        location: Location(index: widgetIndex),
      ),
    );
  }

  static Request prepareDateCreateRequestWithGrading(int widgetIndex) {
    return Request(
      createItem: CreateItemRequest(
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
      ),
    );
  }

  static Request prepareTimeCreateRequest(
    int widgetIndex, {
    String title = '',
  }) {
    return Request(
      createItem: CreateItemRequest(
        item: Item(
          title: title,
          description: '',
          questionItem: QuestionItem(
            question: Question(
                timeQuestion: TimeQuestion(
                  duration: false,
                ),
                required: false),
          ),
        ),
        location: Location(index: widgetIndex),
      ),
    );
  }

  static Request prepareTimeCreateRequestWithGrading(int widgetIndex) {
    return Request(
      createItem: CreateItemRequest(
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
      ),
    );
  }

  static Request prepareLinearScaleCreateRequest(
    int widgetIndex, {
    String title = '',
  }) {
    return Request(
      createItem: CreateItemRequest(
        item: Item(
          title: title,
          description: '',
          questionItem: QuestionItem(
            question: Question(
                scaleQuestion:
                    ScaleQuestion(low: 1, high: 5, lowLabel: '', highLabel: ''),
                required: false),
          ),
        ),
        location: Location(index: widgetIndex),
      ),
    );
  }

  static Request prepareLinearScaleCreateRequestWithGrading(int widgetIndex) {
    return Request(
      createItem: CreateItemRequest(
        item: Item(
          title: '',
          description: '',
          questionItem: QuestionItem(
            question: Question(
                grading: Grading(
                  pointValue: 0,
                  generalFeedback: Feedback(text: ''),
                ),
                scaleQuestion:
                    ScaleQuestion(low: 1, high: 5, lowLabel: '', highLabel: ''),
                required: false),
          ),
        ),
        location: Location(index: widgetIndex),
      ),
    );
  }

  static Request prepareMultipleChoiceGridCreateRequest(
    int widgetIndex, {
    required QuestionType type,
    String title = '',
  }) {
    return Request(
      createItem: CreateItemRequest(
        item: Item(
          title: title,
          description: '',
          questionGroupItem: QuestionGroupItem(
              questions: [
                Question(
                    rowQuestion: RowQuestion(title: 'Row 1'), required: false)
              ],
              grid: Grid(
                  columns: ChoiceQuestion(
                options: [Option(value: 'Column 1')],
                shuffle: false,
                type: CreateQuestionItemHelper.getTypeName(type),
              ))),
        ),
        location: Location(index: widgetIndex),
      ),
    );
  }

  static Request prepareMultipleChoiceGridCreateRequestWithGrading(
      int widgetIndex,
      {required QuestionType type}) {
    return Request(
      createItem: CreateItemRequest(
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
                shuffle: false,
                type: CreateQuestionItemHelper.getTypeName(type),
              ))),
        ),
        location: Location(index: widgetIndex),
      ),
    );
  }

  static Request prepareImageCreateRequest(int widgetIndex) {
    return Request(
        createItem: CreateItemRequest(
      item: (Item(
          title: '',
          imageItem: ImageItem(
              image: Image(
                  contentUri: '',
                  properties: MediaProperties(
                    alignment: 'Left',
                    width: 739,
                  ),
                  sourceUri: '')))),
      location: Location(index: widgetIndex),
    ));
  }

  static Request prepareTextItemCreateRequest(int widgetIndex) {
    return Request(
        createItem: CreateItemRequest(
      item: (Item(title: '', description: '', textItem: TextItem())),
      location: Location(index: widgetIndex),
    ));
  }

  static Request preparePageBreakCreateRequest(int widgetIndex) {
    return Request(
        createItem: CreateItemRequest(
      item: (Item(title: '', description: '', pageBreakItem: PageBreakItem())),
      location: Location(index: widgetIndex),
    ));
  }

  static Request prepareVideoCreateRequest(int widgetIndex) {
    return Request(
        createItem: CreateItemRequest(
      item: (Item(
          title: '',
          description: '',
          videoItem: VideoItem(caption: '', video: Video(youtubeUri: '')))),
      location: Location(index: widgetIndex),
    ));
  }
}
