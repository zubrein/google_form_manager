import 'package:easy_pie_chart/easy_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../color_list.dart';

class MultipleChoiceResponseWidget extends StatefulWidget {
  final List<String> answerList;
  final String title;

  const MultipleChoiceResponseWidget(
      {super.key, required this.answerList, required this.title});

  @override
  State<MultipleChoiceResponseWidget> createState() =>
      _MultipleChoiceResponseWidgetState();
}

class _MultipleChoiceResponseWidgetState
    extends State<MultipleChoiceResponseWidget> {
  Map<String, Color> answersWithColorMap = {};

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
        widget.answerList.isNotEmpty
            ? Row(
                children: [
                  _buildEasyPieChart(),
                  const Gap(16),
                  _buildOptionColorList()
                ],
              )
            : const Text('No response available'),
      ],
    );
  }

  Widget _buildOptionColorList() {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: answersWithColorMap.keys.toList().length,
          itemBuilder: (context, position) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                        color: answersWithColorMap.values.toList()[position],
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                  const Gap(4),
                  Text(answersWithColorMap.keys.toList()[position])
                ],
              ),
            );
          }),
    );
  }

  Widget _buildEasyPieChart() {
    return EasyPieChart(
      shouldAnimate: false,
      pieType: PieType.fill,
      children: getPieList(),
      size: 150,
    );
  }

  List<PieData> getPieList() {
    List<PieData> list = [];
    int colorIndex = 0;
    getPercentage().forEach((key, value) {
      list.add(PieData(value: value, color: colorArray[colorIndex]));
      answersWithColorMap[key] = colorArray[colorIndex];
      colorIndex++;
    });

    return list;
  }

  Map<String, double> getPercentage() {
    Map<String, int> frequencyMap = {};

    for (String element in widget.answerList) {
      if (frequencyMap.containsKey(element)) {
        final int value = frequencyMap[element] ?? 0;
        frequencyMap[element] = value + 1;
      } else {
        frequencyMap[element] = 1;
      }
    }

    int totalElements = widget.answerList.length;
    Map<String, double> percentageMap = {};

    frequencyMap.forEach((key, value) {
      double percentage = (value / totalElements) * 100;
      percentageMap[key] = percentage;
    });

    return percentageMap;
  }
}
