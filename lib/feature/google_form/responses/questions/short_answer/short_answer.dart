import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../edit_form/domain/entities/response_entity.dart';

class ShortAnswerQuestionWidget extends StatefulWidget {
  final ResponseEntity responseEntity;

  const ShortAnswerQuestionWidget({
    super.key,
    required this.responseEntity,
  });

  @override
  State<ShortAnswerQuestionWidget> createState() =>
      _ShortAnswerQuestionWidgetState();
}

class _ShortAnswerQuestionWidgetState extends State<ShortAnswerQuestionWidget> {
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
                                Text(frequencyMap.keys.toList()[position]),
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
