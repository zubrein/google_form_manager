import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';
import 'package:google_form_manager/util/utility.dart';
import 'package:googleapis/forms/v1.dart';

class ModalQuestionItem extends StatefulWidget {
  final List<Question> questionList;
  final List<Option> optionList;
  final QuestionType type;
  final VoidCallback addRequest;
  final Set<String> updateMask;
  final OperationType opType;
  final int questionIndex;
  final String questionTitle;
  final Request request;

  const ModalQuestionItem({
    super.key,
    required this.questionList,
    required this.type,
    required this.optionList,
    required this.addRequest,
    required this.updateMask,
    required this.opType,
    required this.questionIndex,
    required this.questionTitle,
    required this.request,
  });

  @override
  State<ModalQuestionItem> createState() => _ModalQuestionItemState();
}

class _ModalQuestionItemState extends State<ModalQuestionItem>
    with AutomaticKeepAliveClientMixin {
  List<String> caStrings = [];

  @override
  void initState() {
    super.initState();
    _setGrading();
  }

  Future<void> _setGrading() async {
    if (widget.questionList[widget.questionIndex].grading == null) {
      widget.questionList[widget.questionIndex].grading =
          Grading(pointValue: 0, correctAnswers: CorrectAnswers(answers: []));
    } else {
      if (widget.questionList[widget.questionIndex].grading!.pointValue ==
          null) {
        widget.questionList[widget.questionIndex].grading!.pointValue = 0;
      }
      if (widget.questionList[widget.questionIndex].grading!.correctAnswers ==
          null) {
        widget.questionList[widget.questionIndex].grading!.correctAnswers =
            CorrectAnswers(answers: []);
      }
    }

    final answers = widget.questionList[widget.questionIndex].grading
            ?.correctAnswers?.answers ??
        [];
    for (CorrectAnswer i in answers) {
      caStrings.add(i.value ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildQuestionItem();
  }

  Widget _buildQuestionItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '${widget.questionIndex + 1}. ${widget.questionTitle}',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const Gap(8),
          _buildOptionListView(),
          const Gap(16),
          _buildPointWidget(widget.questionList[widget.questionIndex].grading!),
          const Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  void _addCorrectOption(String answer) {
    if (caStrings.contains(answer)) {
      caStrings.remove(answer);
      widget.questionList[widget.questionIndex].grading?.correctAnswers?.answers
          ?.clear();
      for (String i in caStrings) {
        widget
            .questionList[widget.questionIndex].grading?.correctAnswers?.answers
            ?.add(CorrectAnswer(value: i));
      }
    } else {
      caStrings.add(answer);
      widget.questionList[widget.questionIndex].grading?.correctAnswers?.answers
          ?.add(CorrectAnswer(value: answer));
    }

    _addRowRequest();
    setState(() {});
  }

  Widget _buildOptionListView() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.optionList.length,
        itemBuilder: (context, index) {
          return _buildOptionItem(widget.optionList[index], index);
        });
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

  Widget _buildPointWidget(Grading grading) {
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
              size: 18,
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
              size: 18,
            ),
          ),
        ));
  }

  void _increasePoint() {
    setState(() {
      widget.questionList[widget.questionIndex].grading?.pointValue =
          widget.questionList[widget.questionIndex].grading!.pointValue! + 1;
    });
    _addRowRequest();
  }

  void _decreasePoint() {
    setState(() {
      if (widget.questionList[widget.questionIndex].grading!.pointValue! > 0) {
        widget.questionList[widget.questionIndex].grading!.pointValue =
            widget.questionList[widget.questionIndex].grading!.pointValue! - 1;
      }
    });
    _addRowRequest();
  }

  Icon? getIcon(int index) {
    if (widget.type == QuestionType.multipleChoiceGrid) {
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
    if (widget.type == QuestionType.checkboxGrid) {
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

  void _addRowRequest() {
    if (widget.opType == OperationType.update) {
      widget.request.updateItem?.item?.questionGroupItem?.questions =
          widget.questionList;
      widget.updateMask.add(Constants.multipleChoiceRow);
      widget.request.updateItem?.updateMask =
          updateMaskBuilder(widget.updateMask);
    } else if (widget.opType == OperationType.create) {
      widget.request.createItem?.item?.questionGroupItem?.questions =
          widget.questionList;
    }
    widget.addRequest();
  }

  @override
  bool get wantKeepAlive => true;
}
