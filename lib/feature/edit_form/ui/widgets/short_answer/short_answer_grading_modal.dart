import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/util/utility.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:googleapis/forms/v1.dart' as form;

import '../shared/edit_text_widget.dart';

class ShortAnswerGradingModal extends StatefulWidget {
  final Request request;
  final List<CorrectAnswer> answers;
  final OperationType opType;
  final VoidCallback addRequest;
  final Set<String> updateMask;
  final bool isParagraph;
  final form.Feedback? feedback;
  final Grading? grading;

  const ShortAnswerGradingModal({
    super.key,
    required this.request,
    required this.answers,
    required this.opType,
    required this.addRequest,
    required this.updateMask,
    this.isParagraph = false,
    required this.feedback,
    required this.grading,
  });

  @override
  State<ShortAnswerGradingModal> createState() =>
      _ShortAnswerGradingModalState();
}

class _ShortAnswerGradingModalState extends State<ShortAnswerGradingModal> {
  final List<TextEditingController> _controllerList = [];
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.answers.length; i++) {
      _controllerList.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    _feedbackController.text = widget.feedback?.text ?? '';
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPointWidget(),
            if (!widget.isParagraph) _buildAddAnswerListView(),
            const Gap(32),
            _buildFeedbackWidget(),
            const Gap(16),
            const Gap(16),
            _buildDoneButton()
          ],
        ),
      ),
    );
  }

  Widget _buildPointWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('points '),
          _buildPointDecreaseButton(),
          const Gap(8),
          Text(
            '${widget.grading?.pointValue}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Gap(8),
          _buildPointIncreaseButton(),
        ],
      ),
    );
  }

  Widget _buildPointIncreaseButton() {
    return InkWell(
        onTap: () {
          _increasePoint();
        },
        child: const Card(
          color: Colors.black12,
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Icon(
              Icons.arrow_right,
              color: Colors.white,
            ),
          ),
        ));
  }

  Widget _buildPointDecreaseButton() {
    return InkWell(
        onTap: () {
          _decreasePoint();
        },
        child: const Card(
          color: Colors.black12,
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Icon(
              Icons.arrow_left,
              color: Colors.white,
            ),
          ),
        ));
  }

  void _increasePoint() {
    setState(() {
      widget.grading!.pointValue = widget.grading!.pointValue! + 1;
      _addPointRequest();
    });
  }

  void _decreasePoint() {
    setState(() {
      if (widget.grading!.pointValue! > 0) {
        widget.grading!.pointValue = widget.grading!.pointValue! - 1;
        _addPointRequest();
      }
    });
  }

  Widget _buildAddAnswerListView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLabel(Icons.fact_check, 'List correct answer(s)'),
        const Gap(16),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.answers.length,
            itemBuilder: (context, index) {
              return _buildOptionItem(widget.answers[index], index);
            }),
        const Gap(16),
        _buildAddOptionButton()
      ],
    );
  }

  Widget _buildFeedbackWidget() {
    return Column(
      children: [
        _buildLabel(Icons.feedback_outlined, 'Answer feedback'),
        const Gap(16),
        EditTextWidget(
          controller: _feedbackController,
          hint: 'Feedback for all answers',
          onChange: (value) {
            widget.feedback?.text = value;
            _addFeedbackRequest();
          },
        )
      ],
    );
  }

  Widget _buildLabel(IconData icon, String labelText) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.black87,
        ),
        const Gap(8),
        Text(
          labelText,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  Widget _buildAddOptionButton() {
    return GestureDetector(
        onTap: () {
          _addOption();
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueAccent, width: 1.5)),
          child: const Padding(
            padding: EdgeInsets.all(6.0),
            child: Center(
              child: Text(
                'Add a correct answer',
                style: TextStyle(color: Colors.blueAccent, fontSize: 15),
              ),
            ),
          ),
        ));
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

  void _addOption() {
    widget.answers.add(_newOption());
    _controllerList.add(TextEditingController());

    _addRequest();
    setState(() {});
  }

  Widget _buildOptionItem(CorrectAnswer answer, int index) {
    _controllerList[index].text = answer.value ?? 'Correct answer';

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Text('${index + 1}. '),
          Expanded(
            child: _buildOptionEditTextWidget(index),
          ),
          _buildRemoveIcon(index)
        ],
      ),
    );
  }

  EditTextWidget _buildOptionEditTextWidget(int index) {
    return EditTextWidget(
      controller: _controllerList[index],
      hint: 'Correct answer',
      onChange: (value) {
        widget.answers[index].value = value;
        _addRequest();
      },
    );
  }

  Widget _buildRemoveIcon(int index) {
    return GestureDetector(
      onTap: () {
        _removeOption(index);
      },
      child: const Icon(
        Icons.close,
        color: Colors.black38,
        size: 20,
      ),
    );
  }

  void _removeOption(int index) {
    widget.answers.removeAt(index);
    _controllerList.removeAt(index);
    _addRequest();
    setState(() {});
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

  void _addFeedbackRequest() {
    final req = widget.request;
    if (widget.opType == OperationType.update) {
      req.updateItem?.item?.questionItem?.question?.grading?.generalFeedback
          ?.text = widget.feedback?.text;
      widget.updateMask.add(Constants.feedback);
      req.updateItem?.updateMask = updateMaskBuilder(widget.updateMask);
    } else if (widget.opType == OperationType.create) {
      req.createItem?.item?.questionItem?.question?.grading?.generalFeedback
          ?.text = widget.feedback?.text;
    }
    widget.addRequest();
  }

  void _addPointRequest() {
    final req = widget.request;
    if (widget.opType == OperationType.update) {
      req.updateItem?.item?.questionItem?.question?.grading?.pointValue =
          widget.grading?.pointValue;
      widget.updateMask.add(Constants.point);
      req.updateItem?.updateMask = updateMaskBuilder(widget.updateMask);
    } else if (widget.opType == OperationType.create) {
      req.createItem?.item?.questionItem?.question?.grading?.pointValue =
          widget.grading?.pointValue;
    }
    widget.addRequest();
  }

  CorrectAnswer _newOption() => CorrectAnswer(value: 'Correct answer');
}
