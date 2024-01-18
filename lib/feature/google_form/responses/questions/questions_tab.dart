import 'package:flutter/material.dart';

import '../../edit_form/domain/entities/question_answer_entity.dart';
import '../../edit_form/domain/entities/response_entity.dart';
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
  late ResponseEntity selectedQuestion;

  @override
  void initState() {
    super.initState();
    _formCubit = widget.formCubit;
    if (_formCubit.responseEntityList.isNotEmpty) {
      selectedQuestion = _formCubit.responseEntityList[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        _topSection(),
        _getQuestionWidget(selectedQuestion),
      ],
    )

        // ListView.builder(
        //     itemCount: _formCubit.responseEntityList.length,
        //     itemBuilder: (context, position) {
        //       return Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Card(
        //           child: Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: _getQuestionWidget(
        //               _formCubit.responseEntityList[position],
        //             ),
        //           ),
        //         ),
        //       );
        //     }),
        );
  }

  Widget _getQuestionWidget(ResponseEntity responseEntity) {
    if (responseEntity.type == QuestionType.multipleChoice ||
        responseEntity.type == QuestionType.dropdown ||
        responseEntity.type == QuestionType.checkboxes) {
      return MultipleChoiceQuestionWidget(
        responseEntity: responseEntity,
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

  Widget _topSection() {
    return Column(
      children: [_buildDropdown()],
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: InputDecorator(
        decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            contentPadding: EdgeInsets.all(8)),
        child: DropdownButton<ResponseEntity>(
          isExpanded: true,
          isDense: true,
          underline: const SizedBox.shrink(),
          value: selectedQuestion,
          icon: const Icon(Icons.arrow_drop_down_outlined),
          elevation: 16,
          style: const TextStyle(color: Colors.black54),
          onChanged: (ResponseEntity? value) {
            setState(() {
              selectedQuestion = value!;
            });
          },
          items: _formCubit.responseEntityList
              .map<DropdownMenuItem<ResponseEntity>>((ResponseEntity value) {
            return DropdownMenuItem<ResponseEntity>(
              value: value,
              child: Text(
                value.title,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}