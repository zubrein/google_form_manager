import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/util/utility.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:googleapis/forms/v1.dart' as form;

import '../../../domain/enums.dart';
import 'edit_text_widget.dart';

mixin PointAndFeedbackMixin<T extends StatefulWidget> on State<T> {
  Grading get grading;

  Request get request;

  OperationType get opType;

  VoidCallback get addRequest;

  Set<String> get updateMask;

  TextEditingController get feedbackController;

  TextEditingController get correctAnswerController;

  TextEditingController get wrongAnswerController;

  Widget buildPointWidget() {
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
            '${grading.pointValue}',
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
      grading.pointValue = grading.pointValue! + 1;
      _addPointRequest();
    });
  }

  void _decreasePoint() {
    setState(() {
      if (grading.pointValue! > 0) {
        grading.pointValue = grading.pointValue! - 1;
        _addPointRequest();
      }
    });
  }

  Widget buildFeedbackWidget() {
    return Column(
      children: [
        buildLabel(Icons.feedback_outlined, 'Answer feedback'),
        const Gap(16),
        EditTextWidget(
          controller: feedbackController,
          hint: 'Feedback for all answers',
          onChange: (value) {
            grading.generalFeedback ??= form.Feedback(text: '');
            grading.generalFeedback?.text = value;
            _addFeedbackRequest();
          },
        )
      ],
    );
  }

  Widget buildCorrectAnsFeedbackWidget() {
    return Column(
      children: [
        buildLabel(Icons.feedback_outlined, 'Feedback for correct answers'),
        const Gap(16),
        EditTextWidget(
          controller: correctAnswerController,
          hint: 'Enter feedback',
          onChange: (value) {
            grading.whenRight ??= form.Feedback(text: '');
            grading.whenRight?.text = value;
            _addCorrectAnsFeedbackRequest();
          },
        )
      ],
    );
  }

  Widget buildWrongAnsFeedbackWidget() {
    return Column(
      children: [
        buildLabel(Icons.feedback_outlined, 'Feedback for incorrect answers'),
        const Gap(16),
        EditTextWidget(
          controller: wrongAnswerController,
          hint: 'Enter feedback',
          onChange: (value) {
            grading.whenWrong ??= form.Feedback(text: '');
            grading.whenWrong?.text = value;
            _addWrongAnsFeedbackRequest();
          },
        )
      ],
    );
  }

  Widget buildLabel(IconData icon, String labelText) {
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

  void _addPointRequest() {
    if (opType == OperationType.update) {
      request.updateItem?.item?.questionItem?.question?.grading?.pointValue =
          grading.pointValue;
      updateMask.add(Constants.point);
      request.updateItem?.updateMask = updateMaskBuilder(updateMask);
    } else if (opType == OperationType.create) {
      request.createItem?.item?.questionItem?.question?.grading?.pointValue =
          grading.pointValue;
    }
    addRequest();
  }

  void _addFeedbackRequest() {
    if (opType == OperationType.update) {
      request.updateItem?.item?.questionItem?.question?.grading?.generalFeedback
          ?.text = grading.generalFeedback?.text;
      updateMask.add(Constants.feedback);
      request.updateItem?.updateMask = updateMaskBuilder(updateMask);
    } else if (opType == OperationType.create) {
      request.createItem?.item?.questionItem?.question?.grading?.generalFeedback
          ?.text = grading.generalFeedback?.text;
    }
    addRequest();
  }

  void _addCorrectAnsFeedbackRequest() {
    if (opType == OperationType.update) {
      request.updateItem?.item?.questionItem?.question?.grading?.whenRight
          ?.text = grading.whenRight?.text;
      updateMask.add(Constants.correctAnsFeedback);
      request.updateItem?.updateMask = updateMaskBuilder(updateMask);
    } else if (opType == OperationType.create) {
      request.createItem?.item?.questionItem?.question?.grading?.whenRight
          ?.text = grading.whenRight?.text;
    }
    addRequest();
  }

  void _addWrongAnsFeedbackRequest() {
    if (opType == OperationType.update) {
      request.updateItem?.item?.questionItem?.question?.grading?.whenWrong
          ?.text = grading.whenWrong?.text;
      updateMask.add(Constants.wrongAnsFeedback);
      request.updateItem?.updateMask = updateMaskBuilder(updateMask);
    } else if (opType == OperationType.create) {
      request.createItem?.item?.questionItem?.question?.grading?.whenWrong
          ?.text = grading.whenWrong?.text;
    }
    addRequest();
  }
}
