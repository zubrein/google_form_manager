import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ShortAnswerResponseWidget extends StatefulWidget {
  final List<String> answerList;
  final String title;

  const ShortAnswerResponseWidget({
    super.key,
    required this.answerList,
    required this.title,
  });

  @override
  State<ShortAnswerResponseWidget> createState() =>
      _ShortAnswerResponseWidgetState();
}

class _ShortAnswerResponseWidgetState extends State<ShortAnswerResponseWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        Text(
          '${widget.answerList.length} responses',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        const Gap(8),
        ListView.builder(
            itemCount: widget.answerList.length,
            shrinkWrap: true,
            reverse: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, position) {
              return Container(
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    widget.answerList[position],
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ));
            })
      ],
    );
  }
}
