import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LinearScaleResponseWidget extends StatefulWidget {
  final List<String> answerList;
  final String title;

  const LinearScaleResponseWidget({
    super.key,
    required this.answerList,
    required this.title,
  });

  @override
  State<LinearScaleResponseWidget> createState() =>
      _LinearScaleResponseWidgetState();
}

class _LinearScaleResponseWidgetState extends State<LinearScaleResponseWidget> {
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
              ColumnSeries<_ChartData, String>(
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
