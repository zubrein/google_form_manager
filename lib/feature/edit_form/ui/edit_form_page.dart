import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/feature/edit_form/ui/cubit/batch_update_cubit.dart';
import 'package:google_form_manager/feature/edit_form/ui/edit_form_mixin.dart';
import 'package:google_form_manager/feature/edit_form/ui/edit_form_top_panel.dart';
import 'package:googleapis/forms/v1.dart';

import 'cubit/edit_form_cubit.dart';

class EditFormPage extends StatefulWidget {
  final String formId;

  const EditFormPage({super.key, required this.formId});

  @override
  State<EditFormPage> createState() => _EditFormPageState();
}

class _EditFormPageState extends State<EditFormPage> with EditFormMixin {
  late EditFormCubit _editFormCubit;
  late BatchUpdateCubit _batchUpdateCubit;

  @override
  void initState() {
    super.initState();
    _editFormCubit = sl<EditFormCubit>();
    _batchUpdateCubit = sl<BatchUpdateCubit>();
    _editFormCubit.fetchForm(widget.formId);
    _batchUpdateCubit.prepareRequestInitialList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit form')),
      body: Column(
        children: [
          _buildTopPanel(),
          _buildFormListView(),
        ],
      ),
      bottomSheet: _buildBottomPanel(),
    );
  }

  Widget _buildFormListView() {
    return Expanded(
      child: BlocBuilder<EditFormCubit, EditFormState>(
        bloc: _editFormCubit,
        builder: (context, state) {
          if (state is FormListUpdateState) {
            return Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 50),
              child: ListView.builder(
                  itemCount: state.baseItem.length,
                  itemBuilder: (context, position) {
                    final formItem = state.baseItem[position];
                    return buildFormItem(
                      qType: _editFormCubit.checkQuestionType(formItem.item),
                      item: formItem.item,
                      index: position,
                      opType: formItem.opType,
                    );
                  }),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildTopPanel() {
    return EditFormTopPanel(
      onSaveButtonTap: () {
        _batchUpdateCubit.submitForm(widget.formId);
      },
    );
  }

  Widget _buildBottomPanel() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              _editFormCubit.addItem(Item(
                  questionItem: QuestionItem(
                      question: Question(textQuestion: TextQuestion()))));
            },
            child: const SizedBox(
                height: 50, child: Icon(Icons.add_circle_outline)),
          )
        ],
      ),
    );
  }
}
