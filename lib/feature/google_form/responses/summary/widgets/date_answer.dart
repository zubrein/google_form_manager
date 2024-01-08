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
