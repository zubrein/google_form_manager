import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/utils/utils.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/shared/switch_widget.dart';

class ItemBottomWidget extends StatefulWidget {
  final void Function(bool val) onSwitchToggle;
  final bool? isRequired;
  final bool? isQuiz;
  final VoidCallback onDelete;
  final VoidCallback? onAnswerKeyPressed;
  final VoidCallback onTapMenuButton;
  final QuestionType questionType;

  const ItemBottomWidget(
      {super.key,
      required this.onSwitchToggle,
      this.isRequired,
      this.isQuiz,
      required this.onTapMenuButton,
      required this.questionType,
      required this.onDelete,
      this.onAnswerKeyPressed});

  @override
  State<ItemBottomWidget> createState() => _ItemBottomWidgetState();
}

class _ItemBottomWidgetState extends State<ItemBottomWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          widget.isQuiz ?? false
              ? shouldShowButton(widget.questionType)
                  ? _buildAnswerKeyButton()
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
          const Expanded(child: SizedBox()),
          _buildDeleteIcon(),
          const Gap(8),
          shouldShowButton(widget.questionType)
              ? _buildSwitchWidget()
              : const SizedBox.shrink(),
          const Gap(4),
          _menuIcon(),
        ],
      ),
    );
  }

  Widget _buildAnswerKeyButton() {
    return GestureDetector(
      onTap: widget.onAnswerKeyPressed ?? () {},
      child: const Row(
        children: [
          Icon(
            Icons.quiz_outlined,
            color: Colors.blue,
            size: 18,
          ),
          Gap(6),
          Text(
            'Answer key',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }

  Widget _buildSwitchWidget() {
    return Row(children: [
      const Text('Required'),
      const Gap(4),
      SwitchWidget(
        onToggle: widget.onSwitchToggle,
        isRequired: widget.isRequired,
      ),
    ]);
  }

  Widget _buildDeleteIcon() {
    return GestureDetector(
      onTap: widget.onDelete,
      child: const Icon(Icons.delete_rounded, size: 22, color: Colors.black87),
    );
  }

  Widget _menuIcon() {
    List<Widget> menu = [];

    for (int i = 0; i < 3; i++) {
      menu.add(_buildMenuDot());
      menu.add(const Gap(2));
    }

    return InkWell(
      onTap: widget.onTapMenuButton,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: menu,
          ),
        ),
      ),
    );
  }

  DecoratedBox _buildMenuDot() {
    const size = 4.0;
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.black45),
      child: const SizedBox(
        height: size,
        width: size,
      ),
    );
  }
}
