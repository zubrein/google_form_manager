import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/core/helper/logger.dart';
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

  const OptionListWidget({
    super.key,
    required this.optionList,
    required this.type,
    required this.request,
    required this.opType, required this.addRequest,
  });

  @override
  State<OptionListWidget> createState() => _OptionListWidgetState();
}

class _OptionListWidgetState extends State<OptionListWidget>
    with AutomaticKeepAliveClientMixin {
  final List<TextEditingController> _controllerList = [];
  final Set<String> updateMask = {};
  final List<Option> optionList = [];


  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.optionList.length; i++) {
      _controllerList.add(TextEditingController());
      _controllerList[i].text = widget.optionList[i].value ?? '';
      optionList.add(widget.optionList[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _controllerList.length,
        itemBuilder: (context, position) {
          return _buildOptionItem(position);
        });
  }

  Widget _buildOptionItem(int position) {
    return Row(
      children: [
        getIcon() ??
            Text(
              '${position + 1}.',
              style: const TextStyle(fontSize: 16),
            ),
        const Gap(4),
        Expanded(
          child: EditTextWidget(
            controller: _controllerList[position],
            hint: 'Option',
            onChange: (value) {
              Log.info('message');
              final req = widget.request;
              if (widget.opType == OperationType.update) {
                optionList[position].value = value;
                req.updateItem?.item?.questionItem?.question?.choiceQuestion
                    ?.options = optionList;
                updateMask.add(Constants.multipleChoiceValue);
                req.updateItem?.updateMask = updateMaskBuilder(updateMask);
                widget.addRequest();
              }
            },
          ),
        ),
      ],
    );
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

  @override
  bool get wantKeepAlive => true;
}
