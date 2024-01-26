import 'package:flutter/material.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/entities/response_entity.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/google_form/edit_form/ui/cubit/form_cubit.dart';
import 'package:google_form_manager/feature/google_form/responses/summary/widgets/multiple_choice.dart';
import 'package:google_form_manager/feature/google_form/responses/summary/widgets/time_answer.dart';

import '../../edit_form/domain/entities/question_answer_entity.dart';
import 'widgets/checkbox.dart';
import 'widgets/choice_grid.dart';
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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _getResponseWidget(
                  _formCubit.responseEntityList[position].type,
                  _formCubit.responseEntityList[position].questionAnswerEntity,
                  _formCubit.responseEntityList[position].title,
                  responseEntity: _formCubit.responseEntityList[position],
                ),
              ),
            ),
          );
        });
  }

  Widget _getResponseWidget(
    QuestionType type,
    List<QuestionAnswerEntity> answerList,
    String title, {
    ResponseEntity? responseEntity,
  }) {
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
    } else if (type == QuestionType.multipleChoiceGrid ||
        type == QuestionType.checkboxGrid) {
      return ChoiceGridResponseWidget(
        title: title,
        responseEntity: responseEntity!,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
