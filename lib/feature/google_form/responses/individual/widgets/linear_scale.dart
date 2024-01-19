import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:googleapis/forms/v1.dart';

import '../../../edit_form/domain/entities/response_entity.dart';

class LinearScaleIndWidget extends StatefulWidget {
  final ResponseEntity responseEntity;
  final FormResponse formResponse;

  const LinearScaleIndWidget(
      {super.key, required this.responseEntity, required this.formResponse});

  @override
  State<LinearScaleIndWidget> createState() => _LinearScaleIndWidgetState();
}

class _LinearScaleIndWidgetState extends State<LinearScaleIndWidget> {
  String answer = '';
  List<String> linearScaleList = [];

  @override
  void initState() {
    super.initState();
    _prepareLinearScaleList();
  }

  @override
  Widget build(BuildContext context) {
    answer = widget
            .formResponse
            .answers?[widget.responseEntity.questionAnswerEntity[0].questionId]
            ?.textAnswers
            ?.answers?[0]
            .value ??
        '';
    return _buildQuestionView();
  }

  Widget _buildQuestionView() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.responseEntity.title.isNotEmpty
                ? Text(
                    widget.responseEntity.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  )
                : const SizedBox.shrink(),
            const Gap(8),
            widget.responseEntity.description.isNotEmpty
                ? Text(
                    widget.responseEntity.description,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w400),
                  )
                : const SizedBox.shrink(),
            const Gap(8),
            _buildScaleList(),
          ],
        ),
      ),
    );
  }

  Widget _buildScaleList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: linearScaleList.length,
      itemBuilder: (context, index) {
        bool matched = linearScaleList[index] == answer;
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
