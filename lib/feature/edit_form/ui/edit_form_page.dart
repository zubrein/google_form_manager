import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/paragraph_widget.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/short_answer_widget.dart';
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
  late StreamSubscription _editFormCubitSubscription;

  @override
  void initState() {
    super.initState();
    _editFormCubit = sl<EditFormCubit>();
    _editFormCubitSubscription = _editFormCubit.stream.listen(_onListen);
    _editFormCubit.fetchForm(widget.formId);
  }

  void _onListen(EditFormState state) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit form')),
      body: Column(
        children: [
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
                            return _buildShortAnswerWidget(position, formItem);
                          } else if (isParagraph(formItem)) {
                            return _buildParagraphWidget(position, formItem);
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

  ParagraphWidget _buildParagraphWidget(int position, Item? textQuestion) {
    return ParagraphWidget(
      index: position,
      title: textQuestion?.title ?? '',
      description: textQuestion?.description ?? '',
    );
  }

  ShortAnswerWidget _buildShortAnswerWidget(int position, Item? textQuestion) {
    return ShortAnswerWidget(
      index: position,
      title: textQuestion?.title ?? '',
      description: textQuestion?.description ?? '',
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
