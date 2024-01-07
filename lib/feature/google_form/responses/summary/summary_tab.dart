import 'package:flutter/material.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/google_form/edit_form/ui/cubit/form_cubit.dart';
import 'package:google_form_manager/feature/google_form/responses/summary/widgets/multiple_choice.dart';

import 'widgets/checkbox.dart';
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
        itemCount: _formCubit.questionIdVsTypeMap.keys.length,
        itemBuilder: (context, position) {
          String title = '';
          final List<String> answerList = [];
          final String questionId =
              _formCubit.questionIdVsTypeMap.keys.toList()[position].toString();

          for (var element in _formCubit.responseList) {
            element.answers?[questionId]?.textAnswers?.answers
                ?.forEach((element) {
              answerList.add(element.value ?? '');
            });
          }

          for (var element in _formCubit.baseItemList) {
            if (element.item?.questionItem != null) {
              if (element.item!.questionItem!.question!.questionId ==
                  questionId) {
                title = element.item?.title ?? '';
              }
            }
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _getResponseWidget(
                  _formCubit.questionIdVsTypeMap[questionId]!,
                  answerList,
                  title,
                ),
              ),
            ),
          );
        });
  }

  Widget _getResponseWidget(
    QuestionType type,
    List<String> answerList,
    String title,
  ) {
    if (type == QuestionType.multipleChoice || type == QuestionType.dropdown) {
      return MultipleChoiceResponseWidget(
        answerList: answerList,
        title: title,
      );
    } else if (type == QuestionType.shortAnswer ||
        type == QuestionType.paragraph) {
      return ShortAnswerResponseWidget(
        answerList: answerList,
        title: title,
      );
    }else if (type == QuestionType.checkboxes) {
      return CheckBoxResponseWidget(
        answerList: answerList,
        title: title,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
