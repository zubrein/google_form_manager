import 'package:googleapis/forms/v1.dart';

class UpdateRequestBuilderHelper {
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
                textQuestion:
                    TextQuestion(paragraph: isParagraph ? true : null),
                required: false
              ),
            ),
          ),
          location: Location(index: widgetIndex),
          updateMask: ''),
    );
  }
}
