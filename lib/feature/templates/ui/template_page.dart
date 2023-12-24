import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/base.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/core/loading_hud/loading_hud_cubit.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/edit_form/ui/edit_form_page.dart';
import 'package:google_form_manager/feature/templates/ui/create_form_name_input_dialog.dart';
import 'package:google_form_manager/feature/templates/ui/cubit/create_form_cubit.dart';

class TemplatePage extends StatefulWidget {
  const TemplatePage({super.key});

  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  late CreateFormCubit _createFormCubit;
  late LoadingHudCubit _loadingHudCubit;

  @override
  void initState() {
    super.initState();
    _createFormCubit = sl<CreateFormCubit>();
    _loadingHudCubit = sl<LoadingHudCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Base(
      loadingHudCubit: _loadingHudCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create form'),
        ),
        body: BlocConsumer<CreateFormCubit, CreateFormState>(
          bloc: _createFormCubit,
          listener: (context, state) {
            if (state is CreateFormInitiatedState) {
              _loadingHudCubit.show();
            } else if (state is CreateFormSuccessState) {
              _loadingHudCubit.cancel();
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditFormPage(formId: state.formId)));
            } else if (state is CreateFormFailedState) {
              _loadingHudCubit.showError(message: state.error);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildLabel(Constants.createFormLabel),
                  const Gap(16),
                  Row(
                    children: [
                      _buildAddButton(),
                      const Gap(16),
                      _buildQuizButton(),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () async {
        final result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CreateFormNameInputDialog();
          },
        );
        if (result != null) {
          _createFormCubit.createForm(result[0]);
        }
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
    );
  }

  Widget _buildQuizButton() {
    return GestureDetector(
      onTap: () async {
        final result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CreateFormNameInputDialog(isQuiz: true);
          },
        );
        if (result != null) {
          _createFormCubit.createForm(result[0], isQuiz: true);
        }
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(
            Icons.quiz_outlined,
            size: 40,
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
          fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w700),
    );
  }
}
