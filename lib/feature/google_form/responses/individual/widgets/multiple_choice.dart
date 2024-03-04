import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:googleapis/forms/v1.dart';

import '../../../edit_form/domain/entities/response_entity.dart';
import '../../../edit_form/domain/enums.dart';

class MultipleChoiceIndividualWidget extends StatefulWidget {
  final ResponseEntity responseEntity;
  final FormResponse formResponse;

  const MultipleChoiceIndividualWidget(
      {super.key, required this.responseEntity, required this.formResponse});

  @override
  State<MultipleChoiceIndividualWidget> createState() =>
      _MultipleChoiceIndividualWidgetState();
}

class _MultipleChoiceIndividualWidgetState
    extends State<MultipleChoiceIndividualWidget> {
  String answer = '';
  List<Option> options = [];

  @override
  Widget build(BuildContext context) {
    answer = widget
            .formResponse
            .answers?[widget.responseEntity.questionAnswerEntity[0].questionId]
            ?.textAnswers
            ?.answers?[0]
            .value ??
        '';

    options = widget.responseEntity.item?.questionItem?.question?.choiceQuestion
            ?.options ??
        [];
    return _buildQuestionView(options);
  }

  Widget _buildQuestionView(List<Option> options) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                widget.responseEntity.title.isEmpty
                    ? 'Question left blank'
                    : widget.responseEntity.title,
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: widget.responseEntity.title.isEmpty
                        ? FontStyle.italic
                        : null,
                    fontWeight: widget.responseEntity.title.isEmpty
                        ? FontWeight.w400
                        : FontWeight.w700),
              ),
            ),
            const Gap(8),
            widget.responseEntity.description.isNotEmpty
                ? Text(
                    widget.responseEntity.description,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w400),
                  )
                : const SizedBox.shrink(),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: options.length,
                itemBuilder: (context, position) {
                  return _buildOptionItem(options[position]);
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(Option option) {
    bool isOtherAvailable = option.isOther ?? false;

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: !isOtherAvailable
          ? Row(
              children: [
                _getIcon(option) ?? const Icon(Icons.error),
                const Gap(8),
                Expanded(
                  child: Text(option.value ?? ''),
                ),
              ],
            )
          : _buildOtherSection(option),
    );
  }

  Row _buildOtherSection(Option option) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _getIconForOtherSection() ?? const Icon(Icons.error),
        const Gap(8),
        const Text('Other'),
        const Gap(8),
        Column(
          children: [
            Text(showAnsInOtherSection() ? answer : ''),
            const SizedBox(
              width: 100,
              height: 1,
              child: ColoredBox(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget? _getIcon(Option option) {
    if (widget.responseEntity.type == QuestionType.multipleChoice) {
      if (answer.isNotEmpty && answer == option.value) {
        return const Icon(
          Icons.radio_button_checked,
          size: 18,
        );
      } else {
        return const Icon(
          Icons.radio_button_off,
          size: 18,
        );
      }
    }
    if (widget.responseEntity.type == QuestionType.checkboxes) {
      if (answer.isNotEmpty && answer == option.value) {
        return const Icon(
          Icons.check_box,
          size: 18,
        );
      } else {
        return const Icon(
          Icons.check_box_outline_blank,
          size: 18,
        );
      }
    }

    return const SizedBox.shrink();
  }

  Widget? _getIconForOtherSection() {
    if (widget.responseEntity.type == QuestionType.multipleChoice) {
      if (showAnsInOtherSection()) {
        return const Icon(
          Icons.radio_button_checked,
          size: 18,
        );
      } else {
        return const Icon(
          Icons.radio_button_off,
          size: 18,
        );
      }
    }
    if (widget.responseEntity.type == QuestionType.checkboxes) {
      if (showAnsInOtherSection()) {
        return const Icon(
          Icons.check_box,
          size: 18,
        );
      } else {
        return const Icon(
          Icons.check_box_outline_blank,
          size: 18,
        );
      }
    }

    return const SizedBox.shrink();
  }

  bool showAnsInOtherSection() {
    bool value = true;

    for (var element in options) {
      if (element.value == answer) {
        value = false;
      }
    }
    return value;
  }
}
