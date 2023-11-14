import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/helper/create_question_item_helper.dart';
import 'package:googleapis/forms/v1.dart';

class CreateRequestItemHelper {
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

  static Request prepareMultipleChoiceCreateRequest(int widgetIndex,
      {required QuestionType type}) {
    return Request(
      createItem: CreateItemRequest(
        item: Item(
          title: '',
          description: '',
          questionItem: QuestionItem(
            question: Question(
                choiceQuestion: ChoiceQuestion(
                  options: [
                    Option(value: 'Option 1')
                  ],
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
}
