import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/util/utility.dart';
import 'package:googleapis/forms/v1.dart';

import '../shared/edit_text_widget.dart';

class ShortAnswerGradingModal extends StatefulWidget {
  final Request request;
  final List<CorrectAnswer> answers;
  final OperationType opType;
  final VoidCallback addRequest;
  final Set<String> updateMask;
  final bool isParagraph;

  const ShortAnswerGradingModal({
    super.key,
    required this.request,
    required this.answers,
    required this.opType,
    required this.addRequest,
    required this.updateMask,
    this.isParagraph = false,
  });

  @override
  State<ShortAnswerGradingModal> createState() =>
      _ShortAnswerGradingModalState();
}

class _ShortAnswerGradingModalState extends State<ShortAnswerGradingModal> {
  final List<TextEditingController> _controllerList = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.answers.length; i++) {
      _controllerList.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.isParagraph)
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLabel(),
                const Gap(16),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(minHeight: 100, maxHeight: 300),
                  child: ListView.builder(
                      itemCount: widget.answers.length,
                      itemBuilder: (context, index) {
                        return _buildOptionItem(widget.answers[index], index);
                      }),
                ),
                const Gap(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: _buildAddOptionButton()),
                    const Gap(16),
                    _buildDoneButton()
                  ],
                )
              ],
            ),


        ],
      ),
    );
  }

  Widget _buildLabel() {
    return const Row(
      children: [
        Icon(
          Icons.fact_check,
          color: Colors.black87,
        ),
        Gap(8),
        Text(
          'List correct answer(s)',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueAccent, width: 1.5)),
          child: const Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              'Done',
              style: TextStyle(color: Colors.white, fontSize: 15),
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
}
