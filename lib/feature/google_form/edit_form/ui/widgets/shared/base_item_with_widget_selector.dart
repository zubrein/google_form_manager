import 'package:flutter/material.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/entities/base_item_entity.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';

import '../../cubit/form_cubit.dart';
import '../../edit_form_mixin.dart';
import '../../item_type_list_page.dart';
import '../../utils/utils.dart';
import '../helper/create_question_item_helper.dart';
import 'item_top_widget.dart';

class BaseItemWithWidgetSelector extends StatefulWidget {
  final QuestionType questionType;
  final FormCubit formCubit;
  final BaseItemEntity formItem;
  final int index;

  const BaseItemWithWidgetSelector({
    super.key,
    required this.questionType,
    required this.formCubit,
    required this.formItem,
    required this.index,
  });

  @override
  State<BaseItemWithWidgetSelector> createState() =>
      _BaseItemWithWidgetSelectorState();
}

class _BaseItemWithWidgetSelectorState extends State<BaseItemWithWidgetSelector>
    with EditFormMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          widget.questionType == QuestionType.pageBreak
              ? _buildPageBreakLabel()
              : const SizedBox.shrink(),
          ClipRRect(
            borderRadius: _buildItemBorderRadius(),
            child: DecoratedBox(
                decoration: const BoxDecoration(color: Colors.green),
                child: Padding(
                  padding: _buildInnerBoxPadding(),
                  child: DecoratedBox(
                      decoration: _buildInnerBoxDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            GestureDetector(
                                onTap: _onTapTopWidget,
                                child: _buildItemTopWidget()),
                            buildFormItem(
                              qType: widget.questionType,
                              item: widget.formItem.item,
                              index: widget.index,
                              opType: widget.formItem.opType,
                            ),
                          ],
                        ),
                      )),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildPageBreakLabel() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              )),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              'Section',
              style: TextStyle(color: Colors.white),
            ),
          )),
    );
  }

  BorderRadius _buildItemBorderRadius() {
    return widget.questionType == QuestionType.pageBreak
        ? const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          )
        : BorderRadius.circular(8);
  }

  EdgeInsets _buildInnerBoxPadding() {
    return const EdgeInsets.symmetric(vertical: 1).copyWith(left: 8, right: 1);
  }

  BoxDecoration _buildInnerBoxDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(8),
        bottomRight: Radius.circular(8),
      ),
    );
  }

  void _onTapTopWidget() async {
    if (widget.questionType != QuestionType.fileUpload) {
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ItemTypeListPage(selectedType: widget.questionType)));

      if (result != null) {
        formCubit.replaceItem(widget.index,
            CreateQuestionItemHelper.getItem(result[0]), result[0]);
      }
    }
  }

  Widget _buildItemTopWidget() {
    return shouldShowButton(widget.questionType)
        ? Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 1),
                      borderRadius: BorderRadius.circular(4)),
                  child: ItemTopWidget(questionType: widget.questionType)),
            ),
          )
        : const SizedBox.shrink();
  }

  @override
  FormCubit get formCubit => widget.formCubit;
}
