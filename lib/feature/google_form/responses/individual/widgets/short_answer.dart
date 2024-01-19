import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:googleapis/forms/v1.dart';

import '../../../edit_form/domain/entities/response_entity.dart';

class ShortAnswerIndWidget extends StatefulWidget {
  final ResponseEntity responseEntity;
  final FormResponse formResponse;

  const ShortAnswerIndWidget(
      {super.key, required this.responseEntity, required this.formResponse});

  @override
  State<ShortAnswerIndWidget> createState() => _ShortAnswerIndWidgetState();
}

class _ShortAnswerIndWidgetState extends State<ShortAnswerIndWidget> {
  String answer = '';

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
            const Gap(16),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(answer),
                const Divider(
                  color: Colors.black,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
