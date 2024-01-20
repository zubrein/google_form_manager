import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:googleapis/forms/v1.dart';

import '../../../edit_form/domain/entities/response_entity.dart';
import '../../../edit_form/domain/enums.dart';

class ChoiceGridIndWidget extends StatefulWidget {
  final ResponseEntity responseEntity;
  final FormResponse formResponse;

  const ChoiceGridIndWidget(
      {super.key, required this.responseEntity, required this.formResponse});

  @override
  State<ChoiceGridIndWidget> createState() => _ChoiceGridIndWidgetState();
}

class _ChoiceGridIndWidgetState extends State<ChoiceGridIndWidget> {
  @override
  Widget build(BuildContext context) {
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
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.responseEntity.questionAnswerEntity.length,
                itemBuilder: (context, position) {
                  Item? item = widget.responseEntity.item;
                  String questionId = widget
                      .responseEntity.questionAnswerEntity[position].questionId;
                  List<TextAnswer> answers = widget.formResponse
                          .answers?[questionId]?.textAnswers?.answers ??
                      [];
                  return SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Text(item?.questionGroupItem?.questions?[position]
                                .rowQuestion?.title ??
                            ''),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: item?.questionGroupItem?.grid?.columns
                                    ?.options?.length ??
                                0,
                            itemBuilder: (context, index) {
                              String title = item?.questionGroupItem?.grid
                                      ?.columns?.options?[index].value ??
                                  '';

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: getIcon(title, answers),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Icon? getIcon(String answer, List<TextAnswer> answers) {
    if (widget.responseEntity.type == QuestionType.multipleChoiceGrid) {
      return answers.map((e) => e.value).contains(answer)
          ? const Icon(
              Icons.radio_button_checked,
              size: 24,
            )
          : const Icon(
              Icons.radio_button_off,
              size: 24,
            );
    }
    if (widget.responseEntity.type == QuestionType.checkboxGrid) {
      return answers.map((e) => e.value).contains(answer)
          ? const Icon(
              Icons.check_box,
              size: 24,
            )
          : const Icon(
              Icons.check_box_outline_blank,
              size: 24,
            );
    }

    return null;
  }
}
