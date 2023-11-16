import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/cubit/edit_form_cubit.dart';
import 'package:googleapis/forms/v1.dart';

import '../../bottom_modal_operation_constant.dart';
import '../helper/request_builder_helper_mixin.dart';
import '../helper/title_desciption_adder_mixin.dart';
import '../shared/edit_text_widget.dart';

class LinearScaleWidget extends StatefulWidget {
  final int index;
  final Item? item;
  final OperationType operationType;
  final EditFormCubit editFormCubit;

  const LinearScaleWidget({
    super.key,
    required this.index,
    required this.item,
    required this.operationType,
    required this.editFormCubit,
  });

  @override
  State<LinearScaleWidget> createState() => _LinearScaleWidgetState();
}

class _LinearScaleWidgetState extends State<LinearScaleWidget>
    with
        RequestBuilderHelper,
        TitleDescriptionAdderMixin,
        AutomaticKeepAliveClientMixin {
  final TextEditingController _lowLabelController = TextEditingController();
  final TextEditingController _highLabelController = TextEditingController();
  List<int> lowList = [0, 1];
  List<int> highList = List.generate(8, (index) {
    return (index + 2);
  }, growable: false);

  int lowDropdownValue = 1;
  int highDropdownValue = 5;

  @override
  void init() {
    showDescription = widget.item?.description != null;
  }

  @override
  Widget build(BuildContext context) {
    questionController.text = widget.item?.title ?? '';
    descriptionController.text = widget.item?.description ?? '';
    _lowLabelController.text =
        widget.item?.questionItem?.question?.scaleQuestion?.lowLabel ?? '';
    _highLabelController.text =
        widget.item?.questionItem?.question?.scaleQuestion?.highLabel ?? '';
    lowDropdownValue =
        widget.item?.questionItem?.question?.scaleQuestion?.low ?? 1;
    highDropdownValue =
        widget.item?.questionItem?.question?.scaleQuestion?.high ?? 5;
    super.build(context);
    return baseWidget();
  }

  @override
  Widget body() {
    return Column(
      children: [
        buildEditTitleWidget(),
        const Gap(4),
        showDescription
            ? buildEditDescriptionWidget()
            : const SizedBox.shrink(),
        const Gap(8),
        _buildDropdownRow(),
        const Gap(4),
        Row(
          children: [
            Text(
              '$lowDropdownValue. ',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Expanded(child: _buildEditLowLabelWidget()),
          ],
        ),
        const Gap(4),
        Row(
          children: [
            Text(
              '$highDropdownValue. ',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Expanded(child: _buildEditHighLabelWidget()),
          ],
        ),
        const Gap(8),
      ],
    );
  }

  Widget _buildDropdownRow() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _buildLowDropdown(),
          const Gap(16),
          const Text(
            'to',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const Gap(16),
          _buildHighDropdown(),
        ],
      ),
    );
  }

  Widget _buildLowDropdown() {
    return DropdownButton<int>(
      value: lowDropdownValue,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      elevation: 16,
      style: const TextStyle(color: Colors.black54),
      onChanged: (int? value) {
        setState(() {
          lowDropdownValue = value!;
          widget.item?.questionItem?.question?.scaleQuestion?.low =
              lowDropdownValue;
          if (widget.operationType == OperationType.update) {
            request.updateItem?.item?.questionItem?.question?.scaleQuestion
                ?.low = widget.item?.questionItem?.question?.scaleQuestion?.low;
            updateMask.add(Constants.lsLow);
            request.updateItem?.updateMask = updateMaskBuilder(updateMask);
            addRequest();
          } else if (widget.operationType == OperationType.create) {
            request.createItem?.item?.questionItem?.question?.scaleQuestion
                ?.low = widget.item?.questionItem?.question?.scaleQuestion?.low;
            addRequest();
          }
        });
      },
      items: lowList.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }

  Widget _buildHighDropdown() {
    return DropdownButton<int>(
      value: highDropdownValue,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      elevation: 16,
      style: const TextStyle(color: Colors.black54),
      onChanged: (int? value) {
        setState(() {
          highDropdownValue = value!;
          widget.item?.questionItem?.question?.scaleQuestion?.high =
              highDropdownValue;
          if (widget.operationType == OperationType.update) {
            request.updateItem?.item?.questionItem?.question?.scaleQuestion
                    ?.high =
                widget.item?.questionItem?.question?.scaleQuestion?.high;
            updateMask.add(Constants.lsHigh);
            request.updateItem?.updateMask = updateMaskBuilder(updateMask);
            addRequest();
          } else if (widget.operationType == OperationType.create) {
            request.createItem?.item?.questionItem?.question?.scaleQuestion
                    ?.high =
                widget.item?.questionItem?.question?.scaleQuestion?.high;
            addRequest();
          }
        });
      },
      items: highList.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }

  Widget _buildEditLowLabelWidget() {
    return EditTextWidget(
      controller: _lowLabelController,
      onChange: _onChangeLowLabelText,
      hint: 'Label (optional)',
    );
  }

  Widget _buildEditHighLabelWidget() {
    return EditTextWidget(
      controller: _highLabelController,
      onChange: _onChangeHighLabelText,
      hint: 'Label (optional)',
    );
  }

  void _onChangeLowLabelText(String value) {
    var descriptionDebounceTag = '${widget.index} LowLabel';
    widget.item?.questionItem?.question?.scaleQuestion?.lowLabel = value;

    if (widget.operationType == OperationType.update) {
      request.updateItem?.item?.questionItem?.question?.scaleQuestion
              ?.lowLabel =
          widget.item?.questionItem?.question?.scaleQuestion?.lowLabel;
      updateMask.add(Constants.lsLowLabel);
      request.updateItem?.updateMask = updateMaskBuilder(updateMask);
      addRequest(debounceTag: descriptionDebounceTag);
    } else if (widget.operationType == OperationType.create) {
      request.createItem?.item?.questionItem?.question?.scaleQuestion
              ?.lowLabel =
          widget.item?.questionItem?.question?.scaleQuestion?.lowLabel;
      addRequest(debounceTag: descriptionDebounceTag);
    }
  }

  void _onChangeHighLabelText(String value) {
    var descriptionDebounceTag = '${widget.index} highLabel';
    widget.item?.questionItem?.question?.scaleQuestion?.highLabel = value;

    if (widget.operationType == OperationType.update) {
      request.updateItem?.item?.questionItem?.question?.scaleQuestion
              ?.highLabel =
          widget.item?.questionItem?.question?.scaleQuestion?.highLabel;
      updateMask.add(Constants.lsHighLabel);
      request.updateItem?.updateMask = updateMaskBuilder(updateMask);
      addRequest(debounceTag: descriptionDebounceTag);
    } else if (widget.operationType == OperationType.create) {
      request.createItem?.item?.questionItem?.question?.scaleQuestion
              ?.highLabel =
          widget.item?.questionItem?.question?.scaleQuestion?.highLabel;
      addRequest(debounceTag: descriptionDebounceTag);
    }
  }

  @override
  int get widgetIndex => widget.index;

  @override
  QuestionType get questionType => QuestionType.linearScale;

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

  @override
  Request get titleDescRequest => request;

  @override
  Set<String> get titleDescUpdateMask => updateMask;

  @override
  Item? get widgetItem => widget.item;
}
