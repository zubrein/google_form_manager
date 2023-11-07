import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';

class ItemTopWidget extends StatefulWidget {
  final QuestionType questionType;

  const ItemTopWidget({
    super.key,
    required this.questionType,
  });

  @override
  State<ItemTopWidget> createState() => _ItemTopWidgetState();
}

class _ItemTopWidgetState extends State<ItemTopWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            questionTypeIconMap[widget.questionType],
            size: 16,
          ),
          const Gap(4),
          Text(
            questionTypeNameMap[widget.questionType]!,
            style: const TextStyle(color: Colors.black54),
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.black45,
          ),
        ],
      ),
    );
  }
}
