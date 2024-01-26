import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:googleapis/forms/v1.dart';
import '../../../edit_form/domain/entities/response_entity.dart';
import '../color_list.dart';

class ChoiceGridResponseWidget extends StatefulWidget {
  final ResponseEntity responseEntity;
  final String title;

  const ChoiceGridResponseWidget({
    super.key,
    required this.responseEntity,
    required this.title,
  });

  @override
  State<ChoiceGridResponseWidget> createState() =>
      _ChoiceGridResponseWidgetState();
}

class _ChoiceGridResponseWidgetState extends State<ChoiceGridResponseWidget> {
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;

  @override
  void initState() {
    super.initState();

    List<BarChartGroupData> items = [];
    int questionCount =
        widget.responseEntity.item?.questionGroupItem?.questions?.length ?? 0;

    for (var i = 0; i < questionCount; i++) {
      items.add(makeGroupData(
          i, widget.responseEntity.questionAnswerEntity[i].answerList));
    }
    rawBarGroups = items;
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
        const Gap(32),
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: bottomTitles,
                    reservedSize: 42,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: rawBarGroups,
              gridData: const FlGridData(show: true),
            ),
          ),
        )
      ],
    );
  }

  double countStringOccurrences(List<String> list, String target) {
    double count = 0;
    for (String item in list) {
      if (item == target) {
        count++;
      }
    }
    return count;
  }

  BarChartGroupData makeGroupData(int x, List<String> list) {
    List<Option> options =
        widget.responseEntity.item?.questionGroupItem?.grid?.columns?.options ??
            [];

    List<BarChartRodData>? barRods = [];
    int colorIndex = 0;
    for (var element in options) {
      barRods.add(BarChartRodData(
          toY: countStringOccurrences(list, element.value ?? ''),
          width: 24,
          color: colorArray[colorIndex]));
      colorIndex++;
    }

    return BarChartGroupData(barsSpace: 4, x: x, barRods: barRods);
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    List<Question> questions =
        widget.responseEntity.item?.questionGroupItem?.questions ?? [];

    final titles = [];

    for (var element in questions) {
      titles.add(element.rowQuestion?.title ?? '');
    }

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }
}
