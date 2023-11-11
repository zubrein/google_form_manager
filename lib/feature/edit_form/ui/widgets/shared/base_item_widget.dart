import 'package:flutter/material.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/item_type_list_page.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/shared/item_top_widget.dart';

import 'item_bottom_widget.dart';

class BaseItemWidget extends StatefulWidget {
  final Widget childWidget;
  final QuestionType questionType;
  final void Function(bool val) onRequiredSwitchToggle;
  final bool? isRequired;
  final VoidCallback onDelete;

  const BaseItemWidget(
      {super.key,
      required this.childWidget,
      required this.questionType,
      required this.onRequiredSwitchToggle,
      required this.onDelete,
      this.isRequired});

  @override
  State<BaseItemWidget> createState() => _BaseItemWidgetState();
}

class _BaseItemWidgetState extends State<BaseItemWidget> {
  late QuestionType selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = widget.questionType;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                        GestureDetector(
                            onTap: _onTapTopWidget,
                            child: _buildItemTopWidget()),
                        widget.childWidget,
                        ItemBottomWidget(
                          onSwitchToggle: widget.onRequiredSwitchToggle,
                          isRequired: widget.isRequired,
                          onDelete: widget.onDelete,
                        )
                      ],
                    ),
                  )),
            )),
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
}
