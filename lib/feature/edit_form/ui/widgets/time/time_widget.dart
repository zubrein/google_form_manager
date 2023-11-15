import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/cubit/edit_form_cubit.dart';
import 'package:googleapis/forms/v1.dart';

import '../../bottom_modal_operation_constant.dart';
import '../helper/request_builder_helper_mixin.dart';
import '../shared/edit_text_widget.dart';

class TimeWidget extends StatefulWidget {
  final int index;
  final Item? item;
  final OperationType operationType;
  final EditFormCubit editFormCubit;

  const TimeWidget({
    super.key,
    required this.index,
    required this.item,
    required this.operationType,
    required this.editFormCubit,
  });

  @override
  State<TimeWidget> createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget>
    with RequestBuilderHelper, AutomaticKeepAliveClientMixin {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool includeDuration = false;
  String timeLabel = '';

  @override
  void init() {
    showDescription = widget.item?.description != null;
    includeDuration =
        widget.item?.questionItem?.question?.timeQuestion?.duration ?? false;

    timeLabel = includeDuration ? 'Duration' : 'Time';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEditTitleWidget(),
        const Gap(4),
        showDescription
            ? _buildEditDescriptionWidget()
            : const SizedBox.shrink(),
        const Gap(24),
        _buildLabelWidget(timeLabel, Icons.watch_later_outlined),
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
  QuestionType get questionType => QuestionType.time;

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
          } else if (response[0] == ItemMenuOpConstant.includeDuration) {
            timeLabel = 'Duration';
            includeDuration = true;
            widget.item?.questionItem?.question?.timeQuestion?.duration =
                includeDuration;
            _addRequest();
          } else if (response[0] == ItemMenuOpConstant.excludeDuration) {
            timeLabel = 'Time';
            includeDuration = false;
            widget.item?.questionItem?.question?.timeQuestion?.duration =
                includeDuration;
            _addRequest();
          }
          setState(() {});
        }
      };

  void _addRequest() {
    if (widget.operationType == OperationType.update) {
      request.updateItem?.item?.questionItem?.question?.timeQuestion?.duration =
          widget.item?.questionItem?.question?.timeQuestion?.duration;
      updateMask.add(Constants.includeYear);
      request.updateItem?.updateMask = updateMaskBuilder(updateMask);
      addRequest();
    } else if (widget.operationType == OperationType.create) {
      request.createItem?.item?.questionItem?.question?.timeQuestion?.duration =
          widget.item?.questionItem?.question?.timeQuestion?.duration;
      addRequest();
    }
  }

  Widget _buildBottomModal() {
    return AlertDialog(
      alignment: Alignment.bottomCenter,
      content: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Show',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                )),
            InkWell(
              onTap: () {
                _onTapModalItem(ButtonType.description);
              },
              child: _buildModalRow(
                  'Description', showDescription, Icons.description),
            ),
            const Divider(color: Colors.black45),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Answer Type',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                )),
            const Gap(8),
            InkWell(
              onTap: () {
                _onTapModalItem(ButtonType.duration);
              },
              child: _buildModalRow(
                  'Duration', includeDuration, Icons.calendar_month),
            ),
            InkWell(
              onTap: () {
                _onTapModalItem(ButtonType.time);
              },
              child:
                  _buildModalRow('Time', !includeDuration, Icons.watch_later),
            ),
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

  void _onTapModalItem(ButtonType buttonType) {
    if (buttonType == ButtonType.description) {
      showDescription = showDescription ? true : false;
      Navigator.of(context).pop([
        showDescription
            ? ItemMenuOpConstant.hideDesc
            : ItemMenuOpConstant.showDesc
      ]);
    } else if (buttonType == ButtonType.time) {
      includeDuration = false;
      Navigator.of(context).pop([ItemMenuOpConstant.excludeDuration]);
    } else if (buttonType == ButtonType.duration) {
      includeDuration = true;
      Navigator.of(context).pop([ItemMenuOpConstant.includeDuration]);
    }
  }

  Widget _buildLabelWidget(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 140,
          maxWidth: 140,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 14, color: Colors.black45),
                ),
                const Gap(4),
                Icon(
                  icon,
                  color: Colors.black45,
                  size: 18,
                )
              ],
            ),
            const Divider(color: Colors.black45)
          ],
        ),
      ),
    );
  }
}

enum ButtonType { description, time, duration }
