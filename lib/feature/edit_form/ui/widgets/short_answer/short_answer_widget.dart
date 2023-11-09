import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';

import '../helper/request_builder_helper_mixin.dart';
import '../shared/edit_text_widget.dart';

class ShortAnswerWidget extends StatefulWidget {
  final int index;
  final Item? item;
  final OperationType operationType;
  final bool isParagraph;

  const ShortAnswerWidget({
    super.key,
    required this.index,
    required this.item,
    required this.operationType,
    this.isParagraph = false,
  });

  @override
  State<ShortAnswerWidget> createState() => _ShortAnswerWidgetState();
}

class _ShortAnswerWidgetState extends State<ShortAnswerWidget>
    with RequestBuilderHelper {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final Set<String> _updateMask = {};

  @override
  void init() {
    _questionController.text = widget.item?.title ?? '';
    _descriptionController.text = widget.item?.description ?? '';
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
    );
  }

  void _onChangeTitleText(String value) {
    String titleDebounceTag = '${widget.index} title';
    if (widget.operationType == OperationType.update) {
      request.updateItem?.item?.title = value;
      _updateMask.add(Constants.title);
      request.updateItem?.updateMask = updateMaskBuilder(_updateMask);
      addRequest(titleDebounceTag);
    }
  }

  Widget _buildEditDescriptionWidget() {
    return EditTextWidget(
      controller: _descriptionController,
      onChange: _onChangeDescriptionText,
    );
  }

  void _onChangeDescriptionText(String value) {
    var descriptionDebounceTag = '${widget.index} description';

    if (widget.operationType == OperationType.update) {
      request.updateItem?.item?.description = value;
      _updateMask.add('description');
      request.updateItem?.updateMask = updateMaskBuilder(_updateMask);
      addRequest(descriptionDebounceTag);
    }
  }

  @override
  int get widgetIndex => widget.index;

  @override
  QuestionType get questionType => QuestionType.shortAnswer;

  @override
  OperationType get operationType => widget.operationType;
}
