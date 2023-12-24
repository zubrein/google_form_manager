import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/shared/edit_text_widget.dart';
import 'package:googleapis/forms/v1.dart';

class ColumnListWidget extends StatefulWidget {
  final List<Option> optionList;
  final QuestionType type;
  final Request request;
  final OperationType opType;
  final VoidCallback addRequest;
  final Set<String> updateMask;

  const ColumnListWidget({
    super.key,
    required this.optionList,
    required this.type,
    required this.request,
    required this.opType,
    required this.updateMask,
    required this.addRequest,
  });

  @override
  State<ColumnListWidget> createState() => _ColumnListWidgetState();
}

class _ColumnListWidgetState extends State<ColumnListWidget>
    with AutomaticKeepAliveClientMixin {
  final List<TextEditingController> _controllerList = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.optionList.length; i++) {
      _controllerList.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.optionList.length,
            itemBuilder: (context, index) {
              return _buildOptionItem(widget.optionList[index], index);
            }),
        const Gap(16),
        Row(
          children: [
            getIcon()!,
            const Gap(8),
            _buildAddOptionButton(),
          ],
        )
      ],
    );
  }

  Widget _buildAddOptionButton() {
    return GestureDetector(
        onTap: () {
          _addOption();
        },
        child: const Text(
          'Add column',
          style: TextStyle(color: Colors.black45),
        ));
  }

  void _addOption() {
    widget.optionList.add(_newOption());
    _controllerList.add(TextEditingController());

    _addRequest();
    setState(() {});
  }

  void _removeOption(int index) {
    widget.optionList.removeAt(index);
    _controllerList.removeAt(index);
    _addRequest();
    setState(() {});
  }

  Option _newOption() => Option(value: 'Column ${widget.optionList.length + 1}');

  void _addRequest() {
    final req = widget.request;
    if (widget.opType == OperationType.update) {
      req.updateItem?.item?.questionGroupItem?.grid?.columns?.options =
          widget.optionList;
      widget.updateMask.add(Constants.multipleChoiceColumn);
      req.updateItem?.updateMask = updateMaskBuilder(widget.updateMask);
    } else if (widget.opType == OperationType.create) {
      req.createItem?.item?.questionGroupItem?.grid?.columns?.options =
          widget.optionList;
    }
    widget.addRequest();
  }

  Icon? getIcon() {
    if (widget.type == QuestionType.multipleChoiceGrid) {
      return const Icon(
        Icons.radio_button_off,
        size: 18,
      );
    }
    if (widget.type == QuestionType.checkboxGrid) {
      return const Icon(
        Icons.check_box_outline_blank,
        size: 18,
      );
    }

    return null;
  }

  String updateMaskBuilder(Set updateMask) {
    return updateMask.isNotEmpty
        ? updateMask.toString().replaceAll(RegExp(r'[ {}]'), '')
        : '';
  }

  Widget _buildOptionItem(Option option, int index) {
    _controllerList[index].text = option.value ?? 'Column 1';

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          getIcon() ?? _buildNumberBullets(index + 1),
          const Gap(4),
          Expanded(
            child: _buildOptionEditTextWidget(index),
          ),
          widget.optionList.length > 1
              ? _buildRemoveIcon(index)
              : const SizedBox.shrink(),
          const Gap(8),
        ],
      ),
    );
  }

  EditTextWidget _buildOptionEditTextWidget(int index) {
    return EditTextWidget(
      controller: _controllerList[index],
      hint: 'Add column',
      onChange: (value) {
        widget.optionList[index].value = value;
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

  Text _buildNumberBullets(int position) =>
      Text('$position.', style: const TextStyle(fontSize: 16));

  @override
  bool get wantKeepAlive => true;
}
