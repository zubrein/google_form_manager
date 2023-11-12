import 'package:flutter/material.dart';
import 'package:google_form_manager/feature/edit_form/domain/entities/base_item_entity.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/cubit/edit_form_cubit.dart';

import '../../edit_form_mixin.dart';
import '../../item_type_list_page.dart';
import 'item_top_widget.dart';

class BaseItemWithWidgetSelector extends StatefulWidget {
  final QuestionType questionType;
  final EditFormCubit editFormCubit;
  final BaseItemEntity formItem;
  final int index;

  const BaseItemWithWidgetSelector({
    super.key,
    required this.questionType,
    required this.editFormCubit,
    required this.formItem,
    required this.index,
  });

  @override
  State<BaseItemWithWidgetSelector> createState() =>
      _BaseItemWithWidgetSelectorState();
}

class _BaseItemWithWidgetSelectorState extends State<BaseItemWithWidgetSelector>
    with EditFormMixin {
  late QuestionType selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = widget.questionType;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTapTopWidget,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
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
                          _buildItemTopWidget(),
                          buildFormItem(
                            qType: selectedType,
                            item: widget.formItem.item,
                            index: widget.index,
                            opType: widget.formItem.opType,
                          ),
                        ],
                      ),
                    )),
              )),
        ),
      ),
    );
  }

  EdgeInsets _buildInnerBoxPadding() {
    return const EdgeInsets.symmetric(vertical: 1).copyWith(
      left: 8,
      right: 1,
    );
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
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ItemTypeListPage(selectedType: selectedType)));
    if (result[0] != widget.questionType) {
      setState(() {
        selectedType = result[0];
      });
    }
  }

  Widget _buildItemTopWidget() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black54, width: 1),
                borderRadius: BorderRadius.circular(4)),
            child: ItemTopWidget(questionType: selectedType)),
      ),
    );
  }

  @override
  EditFormCubit get editFormCubit => widget.editFormCubit;
}
