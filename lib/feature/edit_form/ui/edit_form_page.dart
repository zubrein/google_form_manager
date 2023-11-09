import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/cubit/batch_update_cubit.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/short_answer/short_answer_widget.dart';
import 'package:googleapis/forms/v1.dart';

import 'cubit/edit_form_cubit.dart';

class EditFormPage extends StatefulWidget {
  final String formId;

  const EditFormPage({super.key, required this.formId});

  @override
  State<EditFormPage> createState() => _EditFormPageState();
}

class _EditFormPageState extends State<EditFormPage> {
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
          Expanded(
            child: BlocBuilder<EditFormCubit, EditFormState>(
              bloc: _editFormCubit,
              builder: (context, state) {
                if (state is FetchFormSuccessState) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView.builder(
                        itemCount: state.form.items?.length,
                        itemBuilder: (context, position) {
                          final formItem = state.form.items?[position];
                          if (isShortAnswer(formItem)) {
                            return _buildShortAnswerWidget(
                                position, formItem, OperationType.update);
                          } else if (isParagraph(formItem)) {
                            return _buildShortAnswerWidget(
                                position, formItem, OperationType.update,
                                isParagraph: true);
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPanel() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.blueGrey,
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  _batchUpdateCubit.submitForm(widget.formId);
                },
                child: const Icon(
                  Icons.check,
                  size: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShortAnswerWidget(
      int position, Item? textQuestion, OperationType type,
      {bool isParagraph = false}) {
    return ShortAnswerWidget(
      index: position,
      item: textQuestion,
      operationType: type,
    );
  }

  bool isShortAnswer(Item? item) {
    if (item?.questionItem?.question?.textQuestion != null &&
        item?.questionItem?.question?.textQuestion?.paragraph == null) {
      return true;
    }
    return false;
  }

  bool isParagraph(Item? item) {
    if (item?.questionItem?.question?.textQuestion?.paragraph != null &&
        item?.questionItem?.question?.textQuestion?.paragraph == true) {
      return true;
    }
    return false;
  }
}
