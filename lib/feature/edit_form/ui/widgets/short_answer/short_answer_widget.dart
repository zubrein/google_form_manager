import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/cubit/edit_form_cubit.dart';
import 'package:googleapis/forms/v1.dart';

import '../../bottom_modal_operation_constant.dart';
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
    showDescription = widget.item?.description != null;
  }

  @override
  Widget build(BuildContext context) {
    _questionController.text = widget.item?.title ?? '';
    _descriptionController.text = widget.item?.description ?? '';
    super.build(context);
    return baseWidget();
  }

  @override
  Widget body() {
    return Column(
      children: [
        _buildEditTitleWidget(),
        const Gap(4),
        showDescription
            ? _buildEditDescriptionWidget()
            : const SizedBox.shrink(),
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
    widget.item?.title = value;
    if (widget.operationType == OperationType.update) {
      request.updateItem?.item?.title = widget.item?.title;
      updateMask.add(Constants.title);
      request.updateItem?.updateMask = updateMaskBuilder(updateMask);
      addRequest(debounceTag: titleDebounceTag);
    } else if (widget.operationType == OperationType.create) {
      request.createItem?.item?.title = widget.item?.title;
      addRequest(debounceTag: titleDebounceTag);
    }
  }

  Widget _buildEditDescriptionWidget() {
    return EditTextWidget(
      controller: _descriptionController,
      onChange: _onChangeDescriptionText,
      hint: 'Description',
    );
  }

  void _onChangeDescriptionText(String value) {
    var descriptionDebounceTag = '${widget.index} description';
    widget.item?.description = value;

    if (widget.operationType == OperationType.update) {
      request.updateItem?.item?.description = widget.item?.description;
      updateMask.add(Constants.description);
      request.updateItem?.updateMask = updateMaskBuilder(updateMask);
      addRequest(debounceTag: descriptionDebounceTag);
    } else if (widget.operationType == OperationType.create) {
      request.createItem?.item?.description = widget.item?.description;
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
          }
          setState(() {});
        }
      };

  Widget _buildBottomModal() {
    return AlertDialog(
      alignment: Alignment.bottomCenter,
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: onTapModalDescription,
              child: _buildModalDescriptionRow(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildModalDescriptionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        showDescription
            ? const Icon(Icons.check, size: 18, color: Colors.green)
            : const SizedBox.shrink()
      ],
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
}
