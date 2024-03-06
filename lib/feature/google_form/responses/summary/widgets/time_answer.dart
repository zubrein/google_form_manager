import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TimeAnswerResponseWidget extends StatefulWidget {
  final List<String> answerList;
  final String title;

  const TimeAnswerResponseWidget({
    super.key,
    required this.answerList,
    required this.title,
  });

  @override
  State<TimeAnswerResponseWidget> createState() =>
      _TimeAnswerResponseWidgetState();
}

class _TimeAnswerResponseWidgetState extends State<TimeAnswerResponseWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            widget.title.isEmpty ? 'Question left blank' : widget.title,
            style: TextStyle(
                fontSize: 16,
                fontStyle: widget.title.isEmpty ? FontStyle.italic : null,
                fontWeight:
                    widget.title.isEmpty ? FontWeight.w400 : FontWeight.w700),
          ),
        ),
        const Gap(4),
        Text(
          '${widget.answerList.length} responses',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Divider(),
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
                  child: Text(widget.answerList[position]));
            })
      ],
    );
  }
}
