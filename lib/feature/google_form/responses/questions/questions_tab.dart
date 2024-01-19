import 'package:flutter/material.dart';

import '../../edit_form/domain/entities/response_entity.dart';
import '../../edit_form/domain/enums.dart';
import '../../edit_form/ui/cubit/form_cubit.dart';
import 'date/date_response.dart';
import 'linear_scale/linear_scale.dart';
import 'multiple_choice/multiple_choice.dart';
import 'short_answer/short_answer.dart';

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
        Expanded(child: _getQuestionWidget(selectedQuestion)),
      ],
    ));
  }

  Widget _getQuestionWidget(ResponseEntity responseEntity) {
    if (responseEntity.type == QuestionType.multipleChoice ||
        responseEntity.type == QuestionType.dropdown ||
        responseEntity.type == QuestionType.checkboxes) {
      return MultipleChoiceQuestionWidget(
        responseEntity: responseEntity,
      );
    } else if (responseEntity.type == QuestionType.shortAnswer ||
        responseEntity.type == QuestionType.paragraph) {
      return ShortAnswerQuestionWidget(
        responseEntity: responseEntity,
      );
    } else if (responseEntity.type == QuestionType.linearScale) {
      return LinearScaleQuestionWidget(
        responseEntity: responseEntity,
      );
    } else if (responseEntity.type == QuestionType.date) {
      return DateQuestionWidget(
        responseEntity: responseEntity,
      );
    } else {
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
