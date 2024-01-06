import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';

import '../../bottom_modal_operation_constant.dart';
import '../../cubit/edit_form_cubit.dart';
import '../helper/request_builder_helper_mixin.dart';
import '../helper/title_desciption_adder_mixin.dart';

class PageBreakWidget extends StatefulWidget {
  final int index;
  final Item? item;
  final OperationType operationType;
  final EditFormCubit editFormCubit;

  const PageBreakWidget({
    super.key,
    required this.index,
    required this.item,
    required this.operationType,
    required this.editFormCubit,
  });

  @override
  State<PageBreakWidget> createState() => _PageBreakWidgetState();
}

class _PageBreakWidgetState extends State<PageBreakWidget>
    with
        RequestBuilderHelper,
        TitleDescriptionAdderMixin,
        AutomaticKeepAliveClientMixin {
  @override
  void init() {
    showDescription = true;
  }

  @override
  Widget build(BuildContext context) {
    questionController.text = widget.item?.title ?? '';
    descriptionController.text = widget.item?.description ?? '';
    super.build(context);
    return baseWidget();
  }

  @override
  Widget body() {
    return Column(
      children: [
        buildEditTitleWidget(hint: 'Section Title (optional)'),
        const Gap(4),
        showDescription
            ? buildEditDescriptionWidget(description: 'Description (optional)')
            : const SizedBox.shrink(),
      ],
    );
  }

  @override
  int get widgetIndex => widget.index;

  @override
  QuestionType get questionType => QuestionType.pageBreak;

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
  Item? get widgetItem => widget.item;

  @override
  Set<String> get titleDescUpdateMask => updateMask;

  @override
  Request get titleDescRequest => request;

  @override
  VoidCallback? get onAnswerKeyPressed => () {};
}
