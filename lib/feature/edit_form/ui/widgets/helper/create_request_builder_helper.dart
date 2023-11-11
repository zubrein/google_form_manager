import 'package:googleapis/forms/v1.dart';

class CreateRequestBuilderHelper {
  static Request prepareShortAnswerCreateRequest(
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
                textQuestion:
                    TextQuestion(paragraph: isParagraph ? true : null),
                required: false),
          ),
        ),
        location: Location(index: widgetIndex),
      ),
    );
  }
}
