import 'package:flutter/material.dart';

import '../../edit_form/domain/entities/question_answer_entity.dart';
import '../../edit_form/domain/enums.dart';
import '../../edit_form/ui/cubit/form_cubit.dart';
import 'widgets/multiple_choice.dart';

class QuestionsResponseTab extends StatefulWidget {
  final FormCubit formCubit;

  const QuestionsResponseTab({super.key, required this.formCubit});

  @override
  State<QuestionsResponseTab> createState() => _QuestionsResponseTabState();
}

class _QuestionsResponseTabState extends State<QuestionsResponseTab> {
  late FormCubit _formCubit;

  @override
  void initState() {
    super.initState();
    _formCubit = widget.formCubit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: _formCubit.responseEntityList.length,
          itemBuilder: (context, position) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _getQuestionWidget(
                    _formCubit.responseEntityList[position].type,
                    _formCubit
                        .responseEntityList[position].questionAnswerEntity,
                    _formCubit.responseEntityList[position].title,
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _getQuestionWidget(
    QuestionType type,
    List<QuestionAnswerEntity> answerList,
    String title,
  ) {
    if (type == QuestionType.multipleChoice ||
        type == QuestionType.dropdown ||
        type == QuestionType.checkboxes) {
      return MultipleChoiceQuestionWidget(
        answerList: answerList.isNotEmpty ? answerList[0].answerList : [],
        title: title,
        type: type,
      );
    }
    // else if (type == QuestionType.shortAnswer ||
    //     type == QuestionType.paragraph) {
    //   return ShortAnswerResponseWidget(
    //     answerList: answerList,
    //     title: title,
    //   );
    // } else if (type == QuestionType.checkboxes) {
    //   return CheckBoxResponseWidget(
    //     answerList: answerList,
    //     title: title,
    //   );
    // } else if (type == QuestionType.linearScale) {
    //   return LinearScaleResponseWidget(
    //     answerList: answerList,
    //     title: title,
    //   );
    // } else if (type == QuestionType.date) {
    //   return DateAnswerResponseWidget(
    //     answerList: answerList,
    //     title: title,
    //   );
    // } else if (type == QuestionType.time) {
    //   return TimeAnswerResponseWidget(
    //     answerList: answerList,
    //     title: title,
    //   );
    // }
    else {
      return const SizedBox.shrink();
    }
  }
}
