import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../edit_form/domain/entities/response_entity.dart';

class LinearScaleQuestionWidget extends StatefulWidget {
  final ResponseEntity responseEntity;

  const LinearScaleQuestionWidget({
    super.key,
    required this.responseEntity,
  });

  @override
  State<LinearScaleQuestionWidget> createState() =>
      _LinearScaleQuestionWidgetState();
}

class _LinearScaleQuestionWidgetState extends State<LinearScaleQuestionWidget> {
  Map<String, int> frequencyMap = {};
  List<String> linearScaleList = [];

  @override
  void initState() {
    super.initState();
    _prepareLinearScaleList();
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
                  _buildScaleList(position),
                  const Gap(4),
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

  Widget _buildScaleList(int position) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: linearScaleList.length,
      itemBuilder: (context, index) {
        bool matched =
            linearScaleList[index] == frequencyMap.keys.toList()[position];
        return Row(
          children: [
            Icon(
              matched ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
              color: Colors.grey,
            ),
            const Gap(8),
            Text(linearScaleList[index])
          ],
        );
      },
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

  void _prepareLinearScaleList() {
    int high = widget
            .responseEntity.item?.questionItem?.question?.scaleQuestion?.high ??
        0;

    int low = widget
            .responseEntity.item?.questionItem?.question?.scaleQuestion?.low ??
        0;

    for (var i = low; i <= high; i++) {
      linearScaleList.add(i.toString());
    }
  }
}
