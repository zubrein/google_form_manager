import 'package:flutter/material.dart';
import 'package:googleapis/forms/v1.dart';

import '../../edit_form/domain/entities/response_entity.dart';
import '../../edit_form/domain/enums.dart';
import '../../edit_form/ui/cubit/form_cubit.dart';
import 'widgets/choice_grid.dart';
import 'widgets/date.dart';
import 'widgets/dropdown.dart';
import 'widgets/linear_scale.dart';
import 'widgets/multiple_choice.dart';
import 'widgets/short_answer.dart';
import 'widgets/time.dart';

class IndividualTab extends StatefulWidget {
  final FormCubit formCubit;

  const IndividualTab({super.key, required this.formCubit});

  @override
  State<IndividualTab> createState() => _IndividualTabState();
}

class _IndividualTabState extends State<IndividualTab> {
  int selectedResponseNumber = 1;
  late FormCubit _formCubit;

  @override
  void initState() {
    super.initState();
    _formCubit = widget.formCubit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTopPanel(),
            Expanded(
              child: ListView.builder(
                  itemCount: _formCubit.responseEntityList.length,
                  itemBuilder: (context, position) {
                    return _getQuestionWidget(
                        _formCubit.responseEntityList[position],
                        _formCubit.responseList[selectedResponseNumber - 1]);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTopPanel() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xff6818B9),
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  _previous();
                },
                icon: const Icon(
                  Icons.keyboard_arrow_left,
                  size: 32,
                  color: Colors.white,
                )),
            Text(
              '$selectedResponseNumber  of  ${_formCubit.responseList.length}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            IconButton(
                onPressed: () {
                  _next();
                },
                icon: const Icon(
                  Icons.chevron_right,
                  size: 32,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }

  void _next() {
    if (selectedResponseNumber < _formCubit.responseList.length) {
      setState(() {
        selectedResponseNumber++;
      });
    }
  }

  void _previous() {
    if (selectedResponseNumber > 1) {
      setState(() {
        selectedResponseNumber--;
      });
    }
  }

  Widget _getQuestionWidget(
    ResponseEntity responseEntity,
    FormResponse response,
  ) {
    if (responseEntity.type == QuestionType.multipleChoice ||
        responseEntity.type == QuestionType.checkboxes) {
      return MultipleChoiceIndividualWidget(
        responseEntity: responseEntity,
        formResponse: response,
      );
    } else if (responseEntity.type == QuestionType.dropdown) {
      return DropDownIndWidget(
        responseEntity: responseEntity,
        formResponse: response,
      );
    } else if (responseEntity.type == QuestionType.shortAnswer ||
        responseEntity.type == QuestionType.paragraph) {
      return ShortAnswerIndWidget(
        responseEntity: responseEntity,
        formResponse: response,
      );
    } else if (responseEntity.type == QuestionType.linearScale) {
      return LinearScaleIndWidget(
        responseEntity: responseEntity,
        formResponse: response,
      );
    } else if (responseEntity.type == QuestionType.date) {
      return DateIndWidget(
        responseEntity: responseEntity,
        formResponse: response,
      );
    } else if (responseEntity.type == QuestionType.time) {
      return TimeIndWidget(
        responseEntity: responseEntity,
        formResponse: response,
      );
    } else if (responseEntity.type == QuestionType.multipleChoiceGrid ||
        responseEntity.type == QuestionType.checkboxGrid) {
      return ChoiceGridIndWidget(
        responseEntity: responseEntity,
        formResponse: response,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
