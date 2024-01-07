import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CheckBoxResponseWidget extends StatefulWidget {
  final List<String> answerList;
  final String title;

  const CheckBoxResponseWidget({
    super.key,
    required this.answerList,
    required this.title,
  });

  @override
  State<CheckBoxResponseWidget> createState() => _CheckBoxResponseWidgetState();
}

class _CheckBoxResponseWidgetState extends State<CheckBoxResponseWidget> {
  late List<_ChartData> data = [];
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    super.initState();

    getHighestFrequency();

    for (var element in widget.answerList) {
      data.add(_ChartData(element, getFrequency(element)));
    }

    _tooltip = TooltipBehavior(enable: false);
  }

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
        const Gap(16),
        SfCartesianChart(
            primaryXAxis:
                CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: getHighestFrequency(),
              interval: 1,
              majorGridLines: const MajorGridLines(width: 0),
            ),
            tooltipBehavior: _tooltip,
            series: <CartesianSeries<_ChartData, String>>[
              BarSeries<_ChartData, String>(
                  dataSource: data,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                  width: 0.4,
                  color: Colors.blue)
            ]),
      ],
    );
  }

  int getFrequency(String answer) {
    Map<String, int> frequencyMap = {};

    for (String element in widget.answerList) {
      if (frequencyMap.containsKey(element)) {
        final int value = frequencyMap[element] ?? 0;
        frequencyMap[element] = value + 1;
      } else {
        frequencyMap[element] = 1;
      }
    }

    return frequencyMap[answer] ?? 0;
  }

  double getHighestFrequency() {
    Map<String, int> frequencyMap = {};

    for (String element in widget.answerList) {
      if (frequencyMap.containsKey(element)) {
        final int value = frequencyMap[element] ?? 0;
        frequencyMap[element] = value + 1;
      } else {
        frequencyMap[element] = 1;
      }
    }

    frequencyMap.values.toList().sort();
    return frequencyMap.values.first.toDouble();
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final int y;
}
