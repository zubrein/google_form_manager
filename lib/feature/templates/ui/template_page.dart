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
import 'template_pages/event_feedback_template.dart';
import 'template_pages/event_registration_template.dart';
import 'template_pages/event_rsvp_template.dart';
import 'template_pages/find_time_template.dart';
import 'template_pages/order_request_template.dart';
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: 0.0,
          title: const Text(
            'Create New Form',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.white,
          leading: Builder(
            builder: (context) {
              return _buildBackIcon(context);
            },
          ),
          actions: [_buildSubscriptionButton(context)],
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
                    const Gap(16),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      shrinkWrap: true,
                      children: [
                        _buildAddButton(),
                        _buildQuizButton(),
                      ],
                    ),
                    const Gap(16),
                    _buildSectionBox(
                        Constants.personalFormLabel,
                        GridView.count(
                          crossAxisCount: 2,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
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
                        )),
                    const Gap(16),
                    _buildSectionBox(
                        Constants.workFormLabel,
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            EventFeedbackTemplate(
                              createFormCubit: _createFormCubit,
                            ),
                            OrderRequestTemplate(
                              createFormCubit: _createFormCubit,
                            ),
                          ],
                        )),
                    const Gap(16),
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
      addButton: Center(
        child: SizedBox(
            height: 40,
            width: 40,
            child: Image.asset(
              blankFormImage,
            )),
      ),
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
    return TemplateButton(
      buttonName: 'Create Quiz',
      buttonImage: blankFormImage,
      addButton: Center(
        child: SizedBox(
            height: 40,
            width: 40,
            child: Image.asset(
              blankFormImage,
            )),
      ),
      buttonOnClick: () async {
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
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
          fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildBackIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: IconButton(
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          )),
    );
  }

  Widget _buildSubscriptionButton(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: Image.asset(
          'assets/app_image/subscription_logo.png',
          width: 28,
          height: 28,
          fit: BoxFit.fill,
        ));
  }

  Widget _buildSectionBox(String label, Widget list) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(8),
            _buildLabel(label),
            const Divider(
              height: 28,
            ),
            list,
            const Gap(8),
          ],
        ),
      ),
    );
  }
}
