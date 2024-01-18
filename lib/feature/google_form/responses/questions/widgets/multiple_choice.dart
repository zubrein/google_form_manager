import 'package:flutter/material.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';

class MultipleChoiceQuestionWidget extends StatefulWidget {
  final List<String> answerList;
  final String title;
  final QuestionType type;

  const MultipleChoiceQuestionWidget(
      {super.key,
      required this.answerList,
      required this.title,
      required this.type});

  @override
  State<MultipleChoiceQuestionWidget> createState() =>
      _MultipleChoiceQuestionWidgetState();
}

class _MultipleChoiceQuestionWidgetState
    extends State<MultipleChoiceQuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
