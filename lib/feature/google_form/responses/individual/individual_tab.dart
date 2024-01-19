import 'package:flutter/material.dart';
import 'package:googleapis/forms/v1.dart';

import '../../edit_form/domain/entities/response_entity.dart';
import '../../edit_form/domain/enums.dart';
import '../../edit_form/ui/cubit/form_cubit.dart';
import 'widgets/dropdown.dart';
import 'widgets/multiple_choice.dart';

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
    return ColoredBox(
      color: Colors.grey.withOpacity(.2),
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
                )),
            Text(
              '$selectedResponseNumber  of  ${_formCubit.responseList.length}',
              style: const TextStyle(fontSize: 16),
            ),
            IconButton(
                onPressed: () {
                  _next();
                },
                icon: const Icon(
                  Icons.chevron_right,
                  size: 32,
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
    }
    // else if (responseEntity.type == QuestionType.shortAnswer ||
    //     responseEntity.type == QuestionType.paragraph) {
    //   return ShortAnswerQuestionWidget(
    //     responseEntity: responseEntity,
    //   );
    // } else if (responseEntity.type == QuestionType.linearScale) {
    //   return LinearScaleQuestionWidget(
    //     responseEntity: responseEntity,
    //   );
    // } else if (responseEntity.type == QuestionType.date) {
    //   return DateQuestionWidget(
    //     responseEntity: responseEntity,
    //   );
    // } else if (responseEntity.type == QuestionType.time) {
    //   return TimeQuestionWidget(
    //     responseEntity: responseEntity,
    //   );
    // }
    else {
      return const SizedBox.shrink();
    }
  }
}
