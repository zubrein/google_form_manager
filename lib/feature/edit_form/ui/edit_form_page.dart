import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_form_manager/base.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/core/loading_hud/loading_hud_cubit.dart';
import 'package:google_form_manager/feature/edit_form/domain/entities/base_item_entity.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/edit_form_top_panel.dart';

import 'cubit/edit_form_cubit.dart';
import 'widgets/helper/create_question_item_helper.dart';
import 'widgets/shared/base_item_with_widget_selector.dart';

class EditFormPage extends StatefulWidget {
  final String formId;

  const EditFormPage({super.key, required this.formId});

  @override
  State<EditFormPage> createState() => _EditFormPageState();
}

class _EditFormPageState extends State<EditFormPage> {
  late EditFormCubit _editFormCubit;
  late LoadingHudCubit _loadingHudCubit;

  @override
  void initState() {
    super.initState();
    _editFormCubit = sl<EditFormCubit>();
    _loadingHudCubit = sl<LoadingHudCubit>();
    _loadingHudCubit.show();
    _editFormCubit.fetchForm(widget.formId);
  }

  @override
  Widget build(BuildContext context) {
    return Base(
      loadingHudCubit: _loadingHudCubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit form')),
        body: Column(
          children: [
            _buildTopPanel(),
            _buildFormListView(),
          ],
        ),
        bottomSheet: _buildBottomPanel(),
      ),
    );
  }

  Widget _buildFormListView() {
    return Expanded(
      child: BlocConsumer<EditFormCubit, EditFormState>(
        bloc: _editFormCubit,
        listener: (context, state) {
          if (state is FormListUpdateState) {
            _loadingHudCubit.cancel();
          }
        },
        builder: (context, state) {
          if (state is FormListUpdateState) {
            return Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 50),
              child: ListView.builder(
                  itemCount: state.baseItem.length,
                  itemBuilder: (context, position) {
                    final formItem = state.baseItem[position];
                    return formItem.visibility
                        ? _buildFormItem(formItem, position)
                        : const SizedBox.shrink();
                  }),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  BaseItemWithWidgetSelector _buildFormItem(
      BaseItemEntity formItem, int position) {
    return BaseItemWithWidgetSelector(
      editFormCubit: _editFormCubit,
      questionType: _editFormCubit.checkQuestionType(formItem.item),
      formItem: formItem,
      index: position,
    );
  }

  Widget _buildTopPanel() {
    return EditFormTopPanel(
      onSaveButtonTap: () async {
        _loadingHudCubit.show();
        final isSubmitted = await _editFormCubit.submitForm(widget.formId);
        if (isSubmitted) {
          pop();
        } else {
          pop();
        }
      },
    );
  }

  void pop() {
    _loadingHudCubit.cancel();
    Navigator.of(context).pop();
  }

  Widget _buildBottomPanel() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () async {
              _editFormCubit.addItem(CreateQuestionItemHelper.getItem(
                QuestionType.shortAnswer,
              ));
            },
            child: const SizedBox(
                height: 50, child: Icon(Icons.add_circle_outline)),
          )
        ],
      ),
    );
  }
}
