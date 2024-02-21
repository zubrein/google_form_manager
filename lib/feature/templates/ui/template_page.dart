import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/base.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/core/loading_hud/loading_hud_cubit.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/google_form/form_tab_page.dart';
import 'package:google_form_manager/feature/templates/domain/entities/template_entity.dart';
import 'package:google_form_manager/feature/templates/ui/constants.dart';
import 'package:google_form_manager/feature/templates/ui/create_form_name_input_dialog.dart';
import 'package:google_form_manager/feature/templates/ui/cubit/create_form_cubit.dart';
import 'package:google_form_manager/feature/templates/ui/template_button.dart';

import '../../google_form/edit_form/domain/constants.dart';
import 'template_pages/event_registration_template.dart';
import 'template_pages/event_rsvp_template.dart';
import 'template_pages/find_time_template.dart';
import 'template_pages/party_time_template.dart';
import 'template_pages/tshirt_size_template.dart';

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
          listener: _onListenFormCubit,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(Constants.createFormLabel),
                    const Gap(16),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      children: [
                        _buildAddButton(),
                        _buildQuizButton(),
                      ],
                    ),
                    const Gap(32),
                    _buildLabel(Constants.personalFormLabel),
                    const Gap(16),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      children: [
                        _buildContactInformationButton(),
                        FindTimeTemplate(
                          createFormCubit: _createFormCubit,
                        ),
                        EventRsvpTemplate(
                          createFormCubit: _createFormCubit,
                        ),
                        PartyInviteTemplate(
                          createFormCubit: _createFormCubit,
                        ),
                        TShirtSizeTemplate(
                          createFormCubit: _createFormCubit,
                        ),
                        EventRegistrationTemplate(
                          createFormCubit: _createFormCubit,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onListenFormCubit(context, state) {
    if (state is CreateFormInitiatedState) {
      _loadingHudCubit.show();
    } else if (state is CreateFormSuccessState) {
      _loadingHudCubit.cancel();
      Navigator.of(context).pop();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FormTabPage(
                    formId: state.formId,
                  )));
    } else if (state is CreateFormFailedState) {
      _loadingHudCubit.showError(message: state.error);
    }
  }

  Widget _buildAddButton() {
    return TemplateButton(
      buttonName: 'Create Form',
      buttonImage: blankFormImage,
      buttonOnClick: () async {
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
    );
  }

  Widget _buildContactInformationButton() {
    return TemplateButton(
      buttonName: 'Contact Information',
      buttonImage: contactInformationImage,
      buttonOnClick: () async {
        _createFormCubit.createTemplate('Contact Information', [
          TemplateItemEntity(QuestionType.shortAnswer, 'Name'),
          TemplateItemEntity(QuestionType.shortAnswer, 'Email'),
          TemplateItemEntity(QuestionType.paragraph, 'Address'),
          TemplateItemEntity(QuestionType.shortAnswer, 'Phone Number'),
          TemplateItemEntity(QuestionType.paragraph, 'Comments'),
        ]);
      },
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
