import 'package:flutter/material.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';

import 'item_bottom_widget.dart';

class BaseItemWidget extends StatefulWidget {
  final Widget childWidget;
  final QuestionType questionType;
  final void Function(bool val) onRequiredSwitchToggle;
  final bool? isRequired;
  final bool? isQuiz;
  final VoidCallback onDelete;
  final VoidCallback? onAnswerKeyPressed;
  final VoidCallback onTapMenuButton;

  const BaseItemWidget({
    super.key,
    required this.childWidget,
    required this.questionType,
    required this.onRequiredSwitchToggle,
    required this.onDelete,
    required this.onTapMenuButton,
    this.isRequired,
    this.isQuiz,
    this.onAnswerKeyPressed,
  });

  @override
  State<BaseItemWidget> createState() => _BaseItemWidgetState();
}

class _BaseItemWidgetState extends State<BaseItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.childWidget,
        widget.questionType != QuestionType.fileUpload
            ? ItemBottomWidget(
                onSwitchToggle: widget.onRequiredSwitchToggle,
                isRequired: widget.isRequired,
                onDelete: widget.onDelete,
                onTapMenuButton: widget.onTapMenuButton,
                questionType: widget.questionType,
                onAnswerKeyPressed: widget.onAnswerKeyPressed,
                isQuiz: widget.isQuiz,
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
