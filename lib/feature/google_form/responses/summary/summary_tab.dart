import 'package:flutter/material.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/google_form/edit_form/ui/cubit/form_cubit.dart';
import 'package:google_form_manager/feature/google_form/responses/summary/widgets/multiple_choice.dart';
import 'package:google_form_manager/feature/google_form/responses/summary/widgets/time_answer.dart';

import '../../edit_form/domain/entities/question_answer_entity.dart';
import 'widgets/checkbox.dart';
import 'widgets/date_answer.dart';
import 'widgets/linear_scale.dart';
import 'widgets/short_answer.dart';

class SummaryTab extends StatefulWidget {
  final FormCubit formCubit;

  const SummaryTab({super.key, required this.formCubit});

  @override
  State<SummaryTab> createState() => _SummaryTabState();
}

class _SummaryTabState extends State<SummaryTab> {
  late FormCubit _formCubit;

  @override
  void initState() {
    super.initState();
    _formCubit = widget.formCubit;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _formCubit.responseEntityList.length,
        itemBuilder: (context, position) {
          // String title = _formCubit.responseEntityList[position].title;
          // final List<String> answerList = [];
          //
          // for (var questionId
          //     in _formCubit.questionTypeVsIdMap.values.toList()[position]) {
          //   for (var response in _formCubit.responseList) {
          //     response.answers?[questionId]?.textAnswers?.answers
          //         ?.forEach((element) {
          //       answerList.add(element.value ?? '');
          //     });
          //   }
          // }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _getResponseWidget(
                  _formCubit.responseEntityList[position].type,
                  _formCubit.responseEntityList[position].questionAnswerEntity,
                  _formCubit.responseEntityList[position].title,
                ),
              ),
            ),
          );
        });
  }

  Widget _getResponseWidget(
    QuestionType type,
    List<QuestionAnswerEntity> answerList,
    String title,
  ) {
    if (type == QuestionType.multipleChoice || type == QuestionType.dropdown) {
      return MultipleChoiceResponseWidget(
        answerList: answerList.isNotEmpty ? answerList[0].answerList : [],
        title: title,
      );
    } else if (type == QuestionType.shortAnswer ||
        type == QuestionType.paragraph) {
      return ShortAnswerResponseWidget(
        answerList: answerList.isNotEmpty ? answerList[0].answerList : [],
        title: title,
      );
    } else if (type == QuestionType.checkboxes) {
      return CheckBoxResponseWidget(
        answerList: answerList.isNotEmpty ? answerList[0].answerList : [],
        title: title,
      );
    } else if (type == QuestionType.linearScale) {
      return LinearScaleResponseWidget(
        answerList: answerList.isNotEmpty ? answerList[0].answerList : [],
        title: title,
      );
    } else if (type == QuestionType.date) {
      return DateAnswerResponseWidget(
        answerList: answerList.isNotEmpty ? answerList[0].answerList : [],
        title: title,
      );
    } else if (type == QuestionType.time) {
      return TimeAnswerResponseWidget(
        answerList: answerList.isNotEmpty ? answerList[0].answerList : [],
        title: title,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
