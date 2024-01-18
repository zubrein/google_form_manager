import 'package:googleapis/forms/v1.dart';

import '../enums.dart';
import 'question_answer_entity.dart';

class ResponseEntity {
  final QuestionType type;
  final String title;
  final String description;
  final Item? item;
  final List<QuestionAnswerEntity> questionAnswerEntity;

  ResponseEntity(
    this.type,
    this.title,
    this.description,
    this.item,
    this.questionAnswerEntity,
  );
}
