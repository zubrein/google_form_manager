import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/cubit/edit_form_cubit.dart';
import 'package:googleapis/forms/v1.dart';

import '../../bottom_modal_operation_constant.dart';
import '../helper/request_builder_helper_mixin.dart';
import '../shared/edit_text_widget.dart';

class DateWidget extends StatefulWidget {
  final int index;
  final Item? item;
  final OperationType operationType;
  final bool isParagraph;
  final EditFormCubit editFormCubit;

  const DateWidget({
    super.key,
    required this.index,
    required this.item,
    required this.operationType,
    required this.editFormCubit,
    this.isParagraph = false,
  });

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget>
    with RequestBuilderHelper, AutomaticKeepAliveClientMixin {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool includeYear = false;
  bool includeTime = false;
  String dateLabel = '';
  String timeLabel = 'Time';

  @override
  void init() {
    showDescription = widget.item?.description != null;
    includeYear =
        widget.item?.questionItem?.question?.dateQuestion?.includeYear ?? false;
    includeTime =
        widget.item?.questionItem?.question?.dateQuestion?.includeTime ?? false;

    dateLabel = includeYear ? 'Day, month, year' : 'Day, month';
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
        _buildLabelWidget(dateLabel, Icons.calendar_month_sharp),
        includeTime
            ? _buildLabelWidget(timeLabel, Icons.watch_later_outlined)
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
  QuestionType get questionType => QuestionType.date;

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
          } else if (response[0] == ItemMenuOpConstant.includeYear) {
            dateLabel = 'Day, month, year';
            includeYear = true;
            widget.item?.questionItem?.question?.dateQuestion?.includeYear =
                includeYear;
            _addYearRequest();
          } else if (response[0] == ItemMenuOpConstant.excludeYear) {
            dateLabel = 'Day, month';
            includeYear = false;
            widget.item?.questionItem?.question?.dateQuestion?.includeYear =
                includeYear;
            _addYearRequest();
          } else if (response[0] == ItemMenuOpConstant.includeTime) {
            includeTime = true;
            widget.item?.questionItem?.question?.dateQuestion?.includeTime =
                includeTime;
            _addTimeRequest();
          } else if (response[0] == ItemMenuOpConstant.excludeTime) {
            includeTime = false;
            widget.item?.questionItem?.question?.dateQuestion?.includeTime =
                includeTime;
            _addTimeRequest();
          }
          setState(() {});
        }
      };

  void _addYearRequest() {
    if (widget.operationType == OperationType.update) {
      request.updateItem?.item?.questionItem?.question?.dateQuestion
              ?.includeYear =
          widget.item?.questionItem?.question?.dateQuestion?.includeYear;
      updateMask.add(Constants.includeYear);
      request.updateItem?.updateMask = updateMaskBuilder(updateMask);
      addRequest();
    } else if (widget.operationType == OperationType.create) {
      request.createItem?.item?.questionItem?.question?.dateQuestion
              ?.includeYear =
          widget.item?.questionItem?.question?.dateQuestion?.includeYear;
      addRequest();
    }
  }

  void _addTimeRequest() {
    if (widget.operationType == OperationType.update) {
      request.updateItem?.item?.questionItem?.question?.dateQuestion
              ?.includeTime =
          widget.item?.questionItem?.question?.dateQuestion?.includeTime;
      updateMask.add(Constants.includeTime);
      request.updateItem?.updateMask = updateMaskBuilder(updateMask);
      addRequest();
    } else if (widget.operationType == OperationType.create) {
      request.createItem?.item?.questionItem?.question?.dateQuestion
              ?.includeTime =
          widget.item?.questionItem?.question?.dateQuestion?.includeTime;
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
          children: [
            InkWell(
              onTap: () {
                _onTapModalItem(ButtonType.description);
              },
              child: _buildModalRow(
                  'Description', showDescription, Icons.description),
            ),
            InkWell(
              onTap: () {
                _onTapModalItem(ButtonType.date);
              },
              child: _buildModalRow(
                  'Include year', includeYear, Icons.calendar_month),
            ),
            InkWell(
              onTap: () {
                _onTapModalItem(ButtonType.time);
              },
              child: _buildModalRow(
                  'Include time', includeTime, Icons.watch_later),
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
    } else if (buttonType == ButtonType.date) {
      includeYear = includeYear ? false : true;
      Navigator.of(context).pop([
        includeYear
            ? ItemMenuOpConstant.includeYear
            : ItemMenuOpConstant.excludeYear
      ]);
    } else if (buttonType == ButtonType.time) {
      includeTime = includeTime ? false : true;
      Navigator.of(context).pop([
        includeTime
            ? ItemMenuOpConstant.includeTime
            : ItemMenuOpConstant.excludeTime
      ]);
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

enum ButtonType { description, date, time }
