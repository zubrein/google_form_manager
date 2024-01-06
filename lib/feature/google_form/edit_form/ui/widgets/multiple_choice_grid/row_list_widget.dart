import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';

import '../shared/edit_text_widget.dart';

class RowListWidget extends StatefulWidget {
  final List<Question> rowList;
  final QuestionType type;
  final Request request;
  final OperationType opType;
  final VoidCallback addRequest;
  final Set<String> updateMask;
  final bool? isRequired;

  const RowListWidget({
    super.key,
    required this.rowList,
    required this.type,
    required this.request,
    required this.opType,
    required this.updateMask,
    required this.addRequest,
    required this.isRequired,
  });

  @override
  State<RowListWidget> createState() => _RowListWidgetState();
}

class _RowListWidgetState extends State<RowListWidget>
    with AutomaticKeepAliveClientMixin {
  final List<TextEditingController> _controllerList = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.rowList.length; i++) {
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
            itemCount: widget.rowList.length,
            itemBuilder: (context, index) {
              return _buildOptionItem(widget.rowList[index], index);
            }),
        const Gap(16),
        _buildAddOptionButton()
      ],
    );
  }

  Widget _buildAddOptionButton() {
    return GestureDetector(
        onTap: () {
          _addOption();
        },
        child: Row(
          children: [
            Text(
              '${widget.rowList.length + 1}',
              style: const TextStyle(color: Colors.black),
            ),
            const Gap(12),
            const Text(
              'Add Row',
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ));
  }

  void _addOption() {
    widget.rowList.add(_newOption());
    _controllerList.add(TextEditingController());

    _addRequest();
    setState(() {});
  }

  void _removeOption(int index) {
    widget.rowList.removeAt(index);
    _controllerList.removeAt(index);
    _addRequest();
    setState(() {});
  }

  Question _newOption() => Question(
      rowQuestion: RowQuestion(title: 'Row ${widget.rowList.length + 1}'),
      required: widget.isRequired);

  void _addRequest() {
    final req = widget.request;
    if (widget.opType == OperationType.update) {
      req.updateItem?.item?.questionGroupItem?.questions = widget.rowList;
      widget.updateMask.add(Constants.multipleChoiceRow);
      req.updateItem?.updateMask = updateMaskBuilder(widget.updateMask);
    } else if (widget.opType == OperationType.create) {
      req.createItem?.item?.questionGroupItem?.questions = widget.rowList;
    }
    widget.addRequest();
  }

  String updateMaskBuilder(Set updateMask) {
    return updateMask.isNotEmpty
        ? updateMask.toString().replaceAll(RegExp(r'[ {}]'), '')
        : '';
  }

  Widget _buildOptionItem(Question option, int index) {
    _controllerList[index].text = option.rowQuestion?.title ?? 'Row 1';

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          _buildNumberBullets(index + 1),
          const Gap(4),
          Expanded(
            child: _buildOptionEditTextWidget(index),
          ),
          widget.rowList.length > 1
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
      hint: 'Add row',
      onChange: (value) {
        widget.rowList[index].rowQuestion?.title = value;
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
