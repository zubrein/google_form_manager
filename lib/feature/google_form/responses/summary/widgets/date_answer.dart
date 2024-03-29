import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class DateAnswerResponseWidget extends StatefulWidget {
  final List<String> answerList;
  final String title;

  const DateAnswerResponseWidget({
    super.key,
    required this.answerList,
    required this.title,
  });

  @override
  State<DateAnswerResponseWidget> createState() =>
      _DateAnswerResponseWidgetState();
}

class _DateAnswerResponseWidgetState extends State<DateAnswerResponseWidget> {
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
                  child: _getDateText(widget.answerList[position]));
            })
      ],
    );
  }

  Widget _getDateText(String date) {
    List<String> filteredDate = date.split(' ');
    String formattedDate =
        DateFormat('d MMM yyyy').format(DateTime.parse(filteredDate[0]));

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: [
          TextSpan(
            text: formattedDate,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: filteredDate.length > 1 ? ' | ' : ''),
          TextSpan(text: filteredDate.length > 1 ? filteredDate[1] : ''),
        ],
      ),
    );
  }
}
