import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../edit_form/domain/entities/response_entity.dart';
import '../../../edit_form/domain/enums.dart';

class ChoiceGridQuestionWidget extends StatefulWidget {
  final ResponseEntity responseEntity;

  const ChoiceGridQuestionWidget({
    super.key,
    required this.responseEntity,
  });

  @override
  State<ChoiceGridQuestionWidget> createState() =>
      _ChoiceGridQuestionWidgetState();
}

class _ChoiceGridQuestionWidgetState extends State<ChoiceGridQuestionWidget> {
  Map<String, int> frequencyMap = {};

  @override
  Widget build(BuildContext context) {
    _prepareResponseMap();

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 16),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuestionView(),
              ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: frequencyMap.keys.toList().length,
                  itemBuilder: (context, position) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _getIcon(),
                                    const Gap(16),
                                    Expanded(
                                        child: Text(frequencyMap.keys
                                            .toList()[position])),
                                  ],
                                ),
                                const Divider()
                              ],
                            ),
                            const Gap(4),
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

  Widget _getIcon() {
    if (widget.responseEntity.type == QuestionType.multipleChoiceGrid) {
      return const Icon(
        Icons.radio_button_checked,
        size: 18,
      );
    }
    if (widget.responseEntity.type == QuestionType.checkboxGrid) {
      return const Icon(
        Icons.check_box,
        size: 18,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildQuestionView() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                widget.responseEntity.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            const Gap(8),
            Text(
              widget.responseEntity.description,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
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
