import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';

import '../../bottom_modal_operation_constant.dart';
import '../../cubit/edit_form_cubit.dart';
import '../helper/request_builder_helper_mixin.dart';
import '../helper/title_desciption_adder_mixin.dart';
import 'column_list_widget.dart';
import 'modal/multiple_choice_grid_grading_modal.dart';
import 'row_list_widget.dart';

class MultipleChoiceGridWidget extends StatefulWidget {
  final int index;
  final Item? item;
  final OperationType operationType;
  final QuestionType type;
  final EditFormCubit editFormCubit;

  const MultipleChoiceGridWidget({
    super.key,
    required this.index,
    required this.item,
    required this.operationType,
    required this.editFormCubit,
    required this.type,
  });

  @override
  State<MultipleChoiceGridWidget> createState() =>
      _MultipleChoiceGridWidgetState();
}

class _MultipleChoiceGridWidgetState extends State<MultipleChoiceGridWidget>
    with
        RequestBuilderHelper,
        TitleDescriptionAdderMixin,
        AutomaticKeepAliveClientMixin {
  @override
  void init() {
    showDescription = widget.item?.description != null;
  }

  @override
  Widget build(BuildContext context) {
    questionController.text = widget.item?.title ?? '';
    descriptionController.text = widget.item?.description ?? '';
    super.build(context);
    return baseWidget();
  }

  @override
  Widget body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildEditTitleWidget(),
        const Gap(4),
        showDescription
            ? buildEditDescriptionWidget()
            : const SizedBox.shrink(),
        const Gap(8),
        const Text(
          'Rows',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        RowListWidget(
          rowList: widget.item?.questionGroupItem?.questions ??
              [Question(rowQuestion: RowQuestion(title: 'Row 1'))],
          type: widget.type,
          request: request,
          opType: widget.operationType,
          updateMask: updateMask,
          addRequest: addRequest,
          isRequired: isRequired,
        ),
        const Gap(16),
        const Text(
          'Columns',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        ColumnListWidget(
          optionList: widget.item?.questionGroupItem?.grid?.columns?.options ??
              [Option(value: 'Column 1')],
          type: widget.type,
          request: request,
          opType: widget.operationType,
          updateMask: updateMask,
          addRequest: addRequest,
        ),
        const Gap(8),
      ],
    );
  }

  @override
  int get widgetIndex => widget.index;

  @override
  QuestionType get questionType => widget.type;

  @override
  OperationType get operationType => widget.operationType;

  @override
  bool? get isRequired =>
      widget.item?.questionGroupItem?.questions?.first.required;

  @override
  EditFormCubit get editFormCubit => widget.editFormCubit;

  @override
  bool get wantKeepAlive => true;

  @override
  VoidCallback get onTapMenuButton => () async {
        BuildContext buildContext = context;
        final response = await showDialog(
            context: buildContext,
            builder: (context) {
              return _buildBottomModal();
            });
        if (response != null) {
          if (response[0] == ItemMenuOpConstant.showDesc) {
            showDescription = true;
          } else if (response[0] == ItemMenuOpConstant.hideDesc) {
            showDescription = false;
          } else if (response[0] == ItemMenuOpConstant.shuffleRow) {
            widget.item?.questionGroupItem?.grid?.shuffleQuestions = true;
            _addShuffleRequest();
          } else if (response[0] == ItemMenuOpConstant.constant) {
            widget.item?.questionGroupItem?.grid?.shuffleQuestions = false;
            _addShuffleRequest();
          }
          setState(() {});
        }
      };

  Widget _buildBottomModal() {
    return AlertDialog(
      alignment: Alignment.bottomCenter,
      content: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Show',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const Gap(16),
            InkWell(
              onTap: onTapModalDescription,
              child: _buildModalRow(
                  'Description', showDescription, Icons.description),
            ),
            const Divider(
              color: Colors.black45,
            ),
            const Gap(12),
            InkWell(
              onTap: onTapModalShuffle,
              child: _buildModalRow(
                  'Shuffle row order',
                  widget.item?.questionGroupItem?.grid?.shuffleQuestions ??
                      false,
                  Icons.description),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildModalRow(String label, bool shouldShowCheck, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          const Gap(8),
          Icon(
            icon,
            color: Colors.black45,
            size: 18,
          ),
          const Gap(4),
          Text(label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              )),
          const Expanded(child: SizedBox()),
          shouldShowCheck
              ? const Icon(Icons.check, size: 18, color: Colors.green)
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  void onTapModalDescription() {
    showDescription = showDescription ? true : false;
    Navigator.of(context).pop([
      showDescription
          ? ItemMenuOpConstant.hideDesc
          : ItemMenuOpConstant.showDesc
    ]);
  }

  void onTapModalShuffle() {
    Navigator.of(context).pop([
      widget.item?.questionGroupItem?.grid?.shuffleQuestions ?? false
          ? ItemMenuOpConstant.constant
          : ItemMenuOpConstant.shuffleRow
    ]);
  }

  @override
  Request get titleDescRequest => request;

  @override
  Set<String> get titleDescUpdateMask => updateMask;

  @override
  Item? get widgetItem => widget.item;

  @override
  void onRequiredButtonToggle(value) {
    widget.item?.questionGroupItem?.questions?.forEach((row) {
      row.required = value;
    });
    _addRowRequest();
  }

  void _addRowRequest() {
    if (operationType == OperationType.update) {
      request.updateItem?.item?.questionGroupItem?.questions =
          widgetItem?.questionGroupItem?.questions;
      updateMask.add(Constants.multipleChoiceRow);
      request.updateItem?.updateMask = updateMaskBuilder(updateMask);
    } else if (operationType == OperationType.create) {
      request.createItem?.item?.questionGroupItem?.questions =
          widgetItem?.questionGroupItem?.questions;
    }
    addRequest();
  }

  void _addShuffleRequest() {
    if (operationType == OperationType.update) {
      request.updateItem?.item?.questionGroupItem?.grid?.shuffleQuestions =
          widgetItem?.questionGroupItem?.grid?.shuffleQuestions;
      updateMask.add(Constants.multipleChoiceGridShuffle);
      request.updateItem?.updateMask = updateMaskBuilder(updateMask);
    } else if (operationType == OperationType.create) {
      request.updateItem?.item?.questionGroupItem?.grid?.shuffleQuestions =
          widgetItem?.questionGroupItem?.grid?.shuffleQuestions;
    }
    addRequest();
  }

  @override
  VoidCallback? get onAnswerKeyPressed => () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                content: MultipleChoiceGridGradingModal(
                  request: request,
                  opType: widget.operationType,
                  updateMask: updateMask,
                  addRequest: addRequest,
                  questionType: widget.type,
                  questionList: widget.item?.questionGroupItem?.questions ??
                      [Question(rowQuestion: RowQuestion(title: 'Row 1'))],
                  optionList:
                      widget.item?.questionGroupItem?.grid?.columns?.options ??
                          [Option(value: 'Column 1')],
                  type: widget.type,
                ),
              );
            });
      };
}
