import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:googleapis/forms/v1.dart';

import '../../../edit_form/domain/entities/response_entity.dart';

class DropDownIndWidget extends StatefulWidget {
  final ResponseEntity responseEntity;
  final FormResponse formResponse;

  const DropDownIndWidget(
      {super.key, required this.responseEntity, required this.formResponse});

  @override
  State<DropDownIndWidget> createState() => _DropDownIndWidgetState();
}

class _DropDownIndWidgetState extends State<DropDownIndWidget> {
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: Text(answer)),
                  const Gap(16),
                  const Icon(Icons.arrow_drop_down)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
