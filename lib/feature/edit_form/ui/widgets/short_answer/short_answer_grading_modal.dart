import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/shared/point_and_feedback_mixin.dart';
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

class _ShortAnswerGradingModalState extends State<ShortAnswerGradingModal>
    with PointAndFeedbackMixin {
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
            buildPointWidget(),
            if (!widget.isParagraph) _buildAddAnswerListView(),
            const Gap(32),
            buildFeedbackWidget(),
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
        buildLabel(Icons.fact_check, 'List correct answer(s)'),
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

  CorrectAnswer _newOption() => CorrectAnswer(value: 'Correct answer');

  @override
  Grading? get grading => widget.grading;

  @override
  VoidCallback get addRequest => widget.addRequest;

  @override
  OperationType get opType => widget.opType;

  @override
  Request get request => widget.request;

  @override
  Set<String> get updateMask => widget.updateMask;

  @override
  form.Feedback? get feedback => widget.feedback;

  @override
  TextEditingController get feedbackController => _feedbackController;
}
