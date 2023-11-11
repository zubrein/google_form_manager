import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/cubit/edit_form_cubit.dart';
import 'package:googleapis/forms/v1.dart';

import '../helper/request_builder_helper_mixin.dart';
import '../shared/edit_text_widget.dart';

class ShortAnswerWidget extends StatefulWidget {
  final int index;
  final Item? item;
  final OperationType operationType;
  final bool isParagraph;
  final EditFormCubit editFormCubit;

  const ShortAnswerWidget({
    super.key,
    required this.index,
    required this.item,
    required this.operationType,
    required this.editFormCubit,
    this.isParagraph = false,
  });

  @override
  State<ShortAnswerWidget> createState() => _ShortAnswerWidgetState();
}

class _ShortAnswerWidgetState extends State<ShortAnswerWidget>
    with RequestBuilderHelper, AutomaticKeepAliveClientMixin {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void init() {
    _questionController.text = widget.item?.title ?? '';
    _descriptionController.text = widget.item?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return baseWidget();
  }

  @override
  Widget body() {
    return Column(
      children: [
        _buildEditTitleWidget(),
        const Gap(4),
        _buildEditDescriptionWidget(),
      ],
    );
  }

  Widget _buildEditTitleWidget() {
    return EditTextWidget(
      controller: _questionController,
      fontSize: 18,
      fontColor: Colors.black,
      fontWeight: FontWeight.w700,
      onChange: _onChangeTitleText,
      hint: 'Question',
    );
  }

  void _onChangeTitleText(String value) {
    String titleDebounceTag = '${widget.index} title';
    if (widget.operationType == OperationType.update) {
      request.updateItem?.item?.title = value;
      updateMask.add(Constants.title);
      request.updateItem?.updateMask = updateMaskBuilder(updateMask);
      addRequest(debounceTag: titleDebounceTag);
    } else if (widget.operationType == OperationType.create) {
      request.createItem?.item?.title = value;
      addRequest(debounceTag: titleDebounceTag);
    }
  }

  Widget _buildEditDescriptionWidget() {
    return EditTextWidget(
      controller: _descriptionController,
      onChange: _onChangeDescriptionText,
      hint: 'Short-answer text',
    );
  }

  void _onChangeDescriptionText(String value) {
    var descriptionDebounceTag = '${widget.index} description';

    if (widget.operationType == OperationType.update) {
      request.updateItem?.item?.description = value;
      updateMask.add(Constants.description);
      request.updateItem?.updateMask = updateMaskBuilder(updateMask);
      addRequest(debounceTag: descriptionDebounceTag);
    } else if (widget.operationType == OperationType.create) {
      request.createItem?.item?.description = value;
      addRequest(debounceTag: descriptionDebounceTag);
    }
  }

  @override
  int get widgetIndex => widget.index;

  @override
  QuestionType get questionType =>
      widget.isParagraph ? QuestionType.paragraph : QuestionType.shortAnswer;

  @override
  OperationType get operationType => widget.operationType;

  @override
  bool? get isRequired => widget.item?.questionItem?.question?.required;

  @override
  EditFormCubit get editFormCubit => widget.editFormCubit;

  @override
  bool get wantKeepAlive => true;
}
