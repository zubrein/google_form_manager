import 'package:flutter/material.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/shared/item_top_widget.dart';

import 'item_bottom_widget.dart';

class BaseItemWidget extends StatelessWidget {
  final Widget childWidget;
  final QuestionType questionType;
  final void Function(bool val) onRequiredSwitchToggle;
  final bool? isRequired;

  const BaseItemWidget(
      {super.key,
      required this.childWidget,
      required this.questionType,
      required this.onRequiredSwitchToggle,
      this.isRequired});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: DecoratedBox(
            decoration: const BoxDecoration(color: Colors.green),
            child: Padding(
              padding: _buildInnerBoxPadding(),
              child: DecoratedBox(
                  decoration: _buildInnerBoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ItemTopWidget(questionType: questionType),
                        childWidget,
                        ItemBottomWidget(
                          onSwitchToggle: onRequiredSwitchToggle,
                          isRequired: isRequired,
                        )
                      ],
                    ),
                  )),
            )),
      ),
    );
  }

  EdgeInsets _buildInnerBoxPadding() {
    return const EdgeInsets.symmetric(vertical: 1).copyWith(
      left: 8,
      right: 1,
    );
  }

  BoxDecoration _buildInnerBoxDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(8),
        bottomRight: Radius.circular(8),
      ),
    );
  }
}
