import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';

import '../../../edit_form/domain/entities/response_entity.dart';

class MultipleChoiceQuestionWidget extends StatefulWidget {
  final ResponseEntity responseEntity;

  const MultipleChoiceQuestionWidget({
    super.key,
    required this.responseEntity,
  });

  @override
  State<MultipleChoiceQuestionWidget> createState() =>
      _MultipleChoiceQuestionWidgetState();
}

class _MultipleChoiceQuestionWidgetState
    extends State<MultipleChoiceQuestionWidget> {
  Map<String, int> frequencyMap = {};

  @override
  Widget build(BuildContext context) {
    _prepareResponseMap();
    List<Option> options = widget.responseEntity.item?.questionItem?.question
            ?.choiceQuestion?.options ??
        [];

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 16),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuestionView(options),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: frequencyMap.keys.toList().length,
                  itemBuilder: (context, position) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _getCheckedIcon() ?? const Icon(Icons.error),
                                const Gap(8),
                                Expanded(
                                  child: _buildOptionTextWidget(
                                      frequencyMap.keys.toList()[position]),
                                ),
                              ],
                            ),
                            const Gap(16),
                            Text(
                              '${frequencyMap.values.toList()[position]} Responses',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
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
            Text(
              widget.responseEntity.description,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
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
                _getIcon() ?? const Icon(Icons.error),
                const Gap(8),
                Expanded(
                  child: _buildOptionTextWidget(option.value ?? ''),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  Widget? _getIcon() {
    if (widget.responseEntity.type == QuestionType.multipleChoice) {
      return const Icon(
        Icons.radio_button_off,
        size: 18,
      );
    }
    if (widget.responseEntity.type == QuestionType.checkboxes) {
      return const Icon(
        Icons.check_box_outline_blank,
        size: 18,
      );
    }

    return const SizedBox.shrink();
  }

  Widget? _getCheckedIcon() {
    if (widget.responseEntity.type == QuestionType.multipleChoice) {
      return const Icon(
        Icons.radio_button_checked,
        size: 18,
      );
    }
    if (widget.responseEntity.type == QuestionType.checkboxes) {
      return const Icon(
        Icons.check_box,
        size: 18,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildOptionTextWidget(String text) {
    return Text(text);
  }

  void _prepareResponseMap() {
    frequencyMap = {};
    for (String element
        in widget.responseEntity.questionAnswerEntity[0].answerList) {
      if (frequencyMap.containsKey(element)) {
        final int value = frequencyMap[element] ?? 0;
        frequencyMap[element] = value + 1;
      } else {
        frequencyMap[element] = 1;
      }
    }
  }
}
