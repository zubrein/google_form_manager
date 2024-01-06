import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';
import 'package:google_form_manager/util/utility.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:googleapis/forms/v1.dart' as form;

import '../shared/point_and_feedback_mixin.dart';

class MultipleChoiceGradingModal extends StatefulWidget {
  final Request request;
  final List<CorrectAnswer> answers;
  final OperationType opType;
  final QuestionType type;
  final VoidCallback addRequest;
  final Set<String> updateMask;
  final QuestionType questionType;
  final Grading? grading;
  final List<Option> optionList;

  const MultipleChoiceGradingModal({
    super.key,
    required this.request,
    required this.answers,
    required this.opType,
    required this.addRequest,
    required this.updateMask,
    required this.questionType,
    required this.grading,
    required this.optionList,
    required this.type,
  });

  @override
  State<MultipleChoiceGradingModal> createState() =>
      _MultipleChoiceGradingModalState();
}

class _MultipleChoiceGradingModalState extends State<MultipleChoiceGradingModal>
    with PointAndFeedbackMixin {
  final TextEditingController _correctAnswerController =
      TextEditingController();
  final TextEditingController _wrongAnswerController = TextEditingController();
  List<String> caStrings = [];

  @override
  void initState() {
    super.initState();

    for (CorrectAnswer i in widget.answers) {
      caStrings.add(i.value ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    _correctAnswerController.text = widget.grading?.whenRight?.text ?? '';
    _wrongAnswerController.text = widget.grading?.whenWrong?.text ?? '';
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPointWidget(),
            _buildAddAnswerListView(),
            const Gap(32),
            buildCorrectAnsFeedbackWidget(),
            const Gap(32),
            buildWrongAnsFeedbackWidget(),
            const Gap(16),
            _buildDoneButton()
          ],
        ),
      ),
    );
  }

  Widget _buildAddAnswerListView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildLabel(Icons.fact_check, 'Select correct answer(s)'),
        const Gap(16),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.optionList.length,
            itemBuilder: (context, index) {
              return _buildOptionItem(widget.optionList[index], index);
            }),
        const Gap(16),
      ],
    );
  }

  Widget _buildDoneButton() {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blueAccent, width: 1.5)),
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Center(
                child: Text(
                  'Done',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
        ));
  }

  void _addCorrectOption(String answer) {
    if (caStrings.contains(answer)) {
      caStrings.remove(answer);
      widget.answers.clear();
      for (String i in caStrings) {
        widget.answers.add(CorrectAnswer(value: i));
      }
    } else {
      caStrings.add(answer);
      widget.answers.add(CorrectAnswer(value: answer));
    }

    _addRequest();
    setState(() {});
  }

  Widget _buildOptionItem(Option option, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _addCorrectOption(widget.optionList[index].value ?? '');
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Row(
          children: [
            getIcon(index) ?? const Icon(Icons.error),
            const Gap(8),
            Expanded(
              child: _buildOptionTextWidget(index),
            ),
            _buildCheckIcon(index)
          ],
        ),
      ),
    );
  }

  Icon? getIcon(int index) {
    if (widget.type == QuestionType.multipleChoice) {
      if (caStrings.contains(widget.optionList[index].value)) {
        return const Icon(
          Icons.radio_button_checked,
          color: Colors.green,
          size: 18,
        );
      } else {
        return const Icon(
          Icons.radio_button_off,
          size: 18,
        );
      }
    }
    if (widget.type == QuestionType.checkboxes) {
      if (caStrings.contains(widget.optionList[index].value)) {
        return const Icon(
          Icons.check_box,
          color: Colors.green,
          size: 18,
        );
      } else {
        return const Icon(
          Icons.check_box_outline_blank,
          size: 18,
        );
      }
    }

    return null;
  }

  Widget _buildOptionTextWidget(index) {
    return Text(widget.optionList[index].value ?? '');
  }

  Widget _buildCheckIcon(int index) {
    if (caStrings.contains(widget.optionList[index].value)) {
      return const Icon(
        Icons.check,
        color: Colors.green,
        size: 20,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  void _addRequest() {
    final req = widget.request;
    if (widget.opType == OperationType.update) {
      req.updateItem?.item?.questionItem?.question?.grading?.correctAnswers
          ?.answers = widget.answers;
      widget.updateMask.add(Constants.correctAnswer);
      req.updateItem?.updateMask = updateMaskBuilder(widget.updateMask);
    } else if (widget.opType == OperationType.create) {
      req.createItem?.item?.questionItem?.question?.grading?.correctAnswers
          ?.answers = widget.answers;
    }
    widget.addRequest();
  }

  @override
  Grading get grading =>
      widget.grading ??
      Grading(
        pointValue: 0,
        whenRight: form.Feedback(text: ''),
        whenWrong: form.Feedback(text: ''),
      );

  @override
  VoidCallback get addRequest => widget.addRequest;

  @override
  OperationType get opType => widget.opType;

  @override
  Request get request => widget.request;

  @override
  Set<String> get updateMask => widget.updateMask;

  @override
  TextEditingController get feedbackController => TextEditingController();

  @override
  TextEditingController get correctAnswerController => _correctAnswerController;

  @override
  TextEditingController get wrongAnswerController => _wrongAnswerController;
}
