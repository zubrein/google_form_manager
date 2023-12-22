import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:googleapis/forms/v1.dart' as form;

import 'modal_queston_item.dart';

class MultipleChoiceGridGradingModal extends StatefulWidget {
  final Request request;
  final OperationType opType;
  final QuestionType type;
  final VoidCallback addRequest;
  final Set<String> updateMask;
  final QuestionType questionType;
  final List<Question> questionList;
  final List<Option> optionList;

  const MultipleChoiceGridGradingModal({
    super.key,
    required this.request,
    required this.opType,
    required this.addRequest,
    required this.updateMask,
    required this.questionType,
    required this.questionList,
    required this.optionList,
    required this.type,
  });

  @override
  State<MultipleChoiceGridGradingModal> createState() =>
      _MultipleChoiceGridGradingModalState();
}

class _MultipleChoiceGridGradingModalState
    extends State<MultipleChoiceGridGradingModal> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildAddAnswerListView(), _buildDoneButton()],
        ),
      ),
    );
  }

  Widget _buildAddAnswerListView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLabel(Icons.fact_check, 'Select correct answer(s)'),
        const Divider(
          color: Colors.grey,
        ),
        const Gap(16),
        _buildQuestionListView(),
        const Gap(16),
      ],
    );
  }

  Widget _buildLabel(IconData icon, String labelText) {
    return Row(
      children: [
        Icon(icon, color: Colors.black87),
        const Gap(8),
        Text(
          labelText,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  Widget _buildQuestionListView() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.questionList.length,
        itemBuilder: (context, index) {
          return ModalQuestionItem(
            questionList: widget.questionList,
            type: widget.type,
            optionList: widget.optionList,
            addRequest: widget.addRequest,
            updateMask: widget.updateMask,
            opType: widget.opType,
            questionIndex: index,
            questionTitle: widget.questionList[index].rowQuestion?.title ?? '',
            grading: _getGrading(widget.questionList[index].grading, index),
            request: widget.request,
          );
        });
  }

  Grading _getGrading(Grading? grading, int index) {
    if (grading == null) {
      return Grading(
          pointValue: 0,
          correctAnswers: CorrectAnswers(answers: []),
          generalFeedback: form.Feedback(text: ''));
    } else {
      if (grading.pointValue == null) {
        widget.questionList[index].grading!.pointValue = 0;
      }
      if (grading.correctAnswers == null) {
        widget.questionList[index].grading!.correctAnswers =
            CorrectAnswers(answers: []);
      }

      return widget.questionList[index].grading!;
    }
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
}
