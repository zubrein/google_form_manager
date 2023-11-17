import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/shared/edit_text_widget.dart';
import 'package:googleapis/forms/v1.dart';

class OptionListWidget extends StatefulWidget {
  final List<Option> optionList;
  final QuestionType type;
  final Request request;
  final OperationType opType;
  final VoidCallback addRequest;
  final Set<String> updateMask;

  const OptionListWidget({
    super.key,
    required this.optionList,
    required this.type,
    required this.request,
    required this.opType,
    required this.updateMask,
    required this.addRequest,
  });

  @override
  State<OptionListWidget> createState() => _OptionListWidgetState();
}

class _OptionListWidgetState extends State<OptionListWidget>
    with AutomaticKeepAliveClientMixin {
  final List<TextEditingController> _controllerList = [];
  final List<Option> optionList = [];
  bool isOtherSectionAvailable = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.optionList.length; i++) {
      isOtherSectionAvailable = widget.optionList[i].isOther ?? false;
      _controllerList.add(TextEditingController());
      optionList.add(widget.optionList[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    isOtherSectionAvailable = optionList.last.isOther ?? false;

    super.build(context);
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: optionList.length,
            itemBuilder: (context, index) {
              return _buildOptionItem(optionList[index], index);
            }),
        const Gap(16),
        Row(
          children: [
            widget.type != QuestionType.dropdown
                ? getIcon()!
                : const SizedBox.shrink(),
            const Gap(8),
            _buildAddOptionButton(),
            !isOtherSectionAvailable && widget.type != QuestionType.dropdown
                ? _buildOrButton()
                : const SizedBox.shrink(),
            !isOtherSectionAvailable && widget.type != QuestionType.dropdown
                ? _buildAddOtherButton()
                : const SizedBox.shrink(),
          ],
        )
      ],
    );
  }

  Widget _buildAddOtherButton() {
    return GestureDetector(
        onTap: () {
          _addOtherOption();
        },
        child: const Text('Add other',
            style: TextStyle(color: Colors.blueAccent)));
  }

  Widget _buildAddOptionButton() {
    return GestureDetector(
        onTap: () {
          _addOption();
        },
        child: const Text(
          'Add Option',
          style: TextStyle(color: Colors.black45),
        ));
  }

  void _addOption() {
    if (isOtherSectionAvailable) {
      optionList.removeLast();
      _controllerList.removeLast();
      optionList.add(_newOption());
      _controllerList.add(TextEditingController());

      optionList.add(_otherOption());
      _controllerList.add(TextEditingController());
    } else {
      optionList.add(_newOption());
      _controllerList.add(TextEditingController());
    }
    _addRequest();
    setState(() {});
  }

  void _removeOption(int index) {
    optionList.removeAt(index);
    _controllerList.removeAt(index);
    _addRequest();
    setState(() {});
  }

  void _addOtherOption() {
    optionList.add(_otherOption());
    _controllerList.add(TextEditingController());
    isOtherSectionAvailable = true;
    _addRequest();
    setState(() {});
  }

  Option _newOption() => Option(value: 'Option ${optionList.length + 1}');

  Option _otherOption() => Option(isOther: true);

  void _addRequest() {
    final req = widget.request;
    if (widget.opType == OperationType.update) {
      req.updateItem?.item?.questionItem?.question?.choiceQuestion?.options =
          optionList;
      widget.updateMask.add(Constants.multipleChoiceValue);
      req.updateItem?.updateMask = updateMaskBuilder(widget.updateMask);
    } else if (widget.opType == OperationType.create) {
      req.createItem?.item?.questionItem?.question?.choiceQuestion?.options =
          optionList;
    }
    widget.addRequest();
  }

  Icon? getIcon() {
    if (widget.type == QuestionType.multipleChoice) {
      return const Icon(
        Icons.radio_button_off,
        size: 18,
      );
    }
    if (widget.type == QuestionType.checkboxes) {
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
    bool isOtherSectionAvailable = option.isOther ?? false;
    _controllerList[index].text = option.value ?? 'Option 1';

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          getIcon() ?? _buildNumberBullets(index + 1),
          const Gap(4),
          Expanded(
            child: isOtherSectionAvailable
                ? _buildOtherTextWidget()
                : _buildOptionEditTextWidget(index),
          ),
          optionList.length > 1
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
      hint: 'Option',
      onChange: (value) {
        optionList[index].value = value;
        _addRequest();
      },
    );
  }

  Widget _buildOtherTextWidget() {
    return const Padding(
      padding: EdgeInsets.only(left: 5.0),
      child: Text('Other'),
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
      Text('${position}.', style: const TextStyle(fontSize: 16));

  Widget _buildOrButton() {
    return const Text('  or  ', style: TextStyle(color: Colors.black));
  }

  @override
  bool get wantKeepAlive => true;
}
