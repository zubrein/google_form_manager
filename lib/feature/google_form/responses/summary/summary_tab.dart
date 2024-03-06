import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/entities/response_entity.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/google_form/edit_form/ui/cubit/form_cubit.dart';
import 'package:google_form_manager/feature/google_form/responses/summary/widgets/multiple_choice.dart';
import 'package:google_form_manager/feature/google_form/responses/summary/widgets/time_answer.dart';

import '../../edit_form/domain/entities/question_answer_entity.dart';
import 'widgets/checkbox.dart';
import 'widgets/choice_grid.dart';
import 'widgets/date_answer.dart';
import 'widgets/linear_scale.dart';
import 'widgets/short_answer.dart';

class SummaryTab extends StatefulWidget {
  final FormCubit formCubit;

  const SummaryTab({super.key, required this.formCubit});

  @override
  State<SummaryTab> createState() => _SummaryTabState();
}

class _SummaryTabState extends State<SummaryTab> {
  late FormCubit _formCubit;

  @override
  void initState() {
    super.initState();
    _formCubit = widget.formCubit;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _formCubit.responseEntityList.length + 1,
        itemBuilder: (context, position) {
          return position == 0
              ? _buildTopWidget()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _getResponseWidget(
                        _formCubit.responseEntityList[position - 1].type,
                        _formCubit.responseEntityList[position - 1]
                            .questionAnswerEntity,
                        _formCubit.responseEntityList[position - 1].title,
                        responseEntity:
                            _formCubit.responseEntityList[position - 1],
                      ),
                    ),
                  ),
                );
        });
  }

  Widget _buildTopWidget() {
    return _formCubit.isQuiz
        ? Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAverageWidget(),
                    _buildMedianWidget(),
                    _buildRangeWidget(),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildMedianWidget() {
    return Column(
      children: [
        const Text(
          'Median',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const Gap(8),
        Text(
          '${median()}/${_formCubit.totalPoint}',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAverageWidget() {
    return Column(
      children: [
        const Text(
          'Average',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const Gap(8),
        Text(
          '${average().toStringAsFixed(1)}/${_formCubit.totalPoint}',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRangeWidget() {
    return Column(
      children: [
        const Text(
          'Range',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const Gap(8),
        Text(
          range(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  int median() {
    final List<double> numbers = [];

    for (var response in _formCubit.responseList) {
      double totalScore = 0.0;
      response.answers?.values.toList().forEach((answer) {
        double score = answer.grade?.score ?? 0.0;
        totalScore += score;
      });
      numbers.add(totalScore);
    }

    numbers.sort();
    int middleIndex = numbers.length ~/ 2;

    if (numbers.length % 2 == 1) {
      return numbers[middleIndex].floor();
    } else {
      return (numbers[middleIndex - 1]).floor();
    }
  }

  String range() {
    final List<double> numbers = [];

    for (var response in _formCubit.responseList) {
      double totalScore = 0.0;
      response.answers?.values.toList().forEach((answer) {
        double score = answer.grade?.score ?? 0.0;
        totalScore += score;
      });
      numbers.add(totalScore);
    }

    numbers.sort();
    return numbers.length > 1
        ? '${numbers.first.floor()}-${numbers.last.floor()}'
        : '${numbers.first.floor()}';
  }

  double average() {
    final List<double> numbers = [];

    for (var response in _formCubit.responseList) {
      double totalScore = 0.0;
      response.answers?.values.toList().forEach((answer) {
        double score = answer.grade?.score ?? 0.0;
        totalScore += score;
      });
      numbers.add(totalScore);
    }

    double sum = 0;
    for (double number in numbers) {
      sum += number;
    }
    if (_formCubit.responseList.isNotEmpty) {
      return sum / _formCubit.responseList.length;
    } else {
      return 0.0;
    }
  }

  Widget _getResponseWidget(
    QuestionType type,
    List<QuestionAnswerEntity> answerList,
    String title, {
    ResponseEntity? responseEntity,
  }) {
    if (type == QuestionType.multipleChoice || type == QuestionType.dropdown) {
      return MultipleChoiceResponseWidget(
        answerList: answerList.isNotEmpty ? answerList[0].answerList : [],
        title: title,
      );
    } else if (type == QuestionType.shortAnswer ||
        type == QuestionType.paragraph) {
      return ShortAnswerResponseWidget(
        answerList: answerList.isNotEmpty ? answerList[0].answerList : [],
        title: title,
      );
    } else if (type == QuestionType.checkboxes) {
      return CheckBoxResponseWidget(
        answerList: answerList.isNotEmpty ? answerList[0].answerList : [],
        title: title,
      );
    } else if (type == QuestionType.linearScale) {
      return LinearScaleResponseWidget(
        answerList: answerList.isNotEmpty ? answerList[0].answerList : [],
        title: title,
      );
    } else if (type == QuestionType.date) {
      return DateAnswerResponseWidget(
        answerList: answerList.isNotEmpty ? answerList[0].answerList : [],
        title: title,
      );
    } else if (type == QuestionType.time) {
      return TimeAnswerResponseWidget(
        answerList: answerList.isNotEmpty ? answerList[0].answerList : [],
        title: title,
      );
    } else if (type == QuestionType.multipleChoiceGrid ||
        type == QuestionType.checkboxGrid) {
      return ChoiceGridResponseWidget(
        title: title,
        responseEntity: responseEntity!,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
