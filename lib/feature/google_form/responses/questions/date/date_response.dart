import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../edit_form/domain/entities/response_entity.dart';

class DateQuestionWidget extends StatefulWidget {
  final ResponseEntity responseEntity;

  const DateQuestionWidget({
    super.key,
    required this.responseEntity,
  });

  @override
  State<DateQuestionWidget> createState() => _DateQuestionWidgetState();
}

class _DateQuestionWidgetState extends State<DateQuestionWidget> {
  Map<String, int> frequencyMap = {};

  @override
  void initState() {
    super.initState();
  }

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
            children: [_buildQuestionView(), _buildResponseList()],
          ),
        ),
      ),
    );
  }

  Widget _buildResponseList() {
    return ListView.builder(
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
                  Text(
                    frequencyMap.keys.toList()[position].replaceAll('-', '/'),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const Gap(16),
                  Text(
                    '${frequencyMap.values.toList()[position]} Responses',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.blue),
                  ),
                ],
              ),
            ),
          );
        });
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
