import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';

import 'shared/base_item_widget.dart';
import 'shared/edit_text_widget.dart';

class ParagraphWidget extends StatefulWidget {
  final int index;
  final String title;
  final String description;

  const ParagraphWidget({
    super.key,
    required this.index,
    required this.title,
    required this.description,
  });

  @override
  State<ParagraphWidget> createState() => _ParagraphWidgetState();
}

class _ParagraphWidgetState extends State<ParagraphWidget> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _questionController.text = widget.title;

    return BaseItemWidget(
      questionType: QuestionType.paragraph,
      childWidget: Column(
        children: [
          EditTextWidget(
            controller: _questionController,
            fontSize: 18,
            fontColor: Colors.black,
            fontWeight: FontWeight.w700,
          ),
          const Gap(4),
          EditTextWidget(controller: _descriptionController),
        ],
      ),
    );
  }
}
