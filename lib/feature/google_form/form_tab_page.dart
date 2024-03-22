import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/base.dart';
import 'package:google_form_manager/feature/google_form/edit_form/ui/edit_form_page.dart';
import 'package:google_form_manager/feature/google_form/responses/response_page.dart';
import 'package:onepref/onepref.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/di/dependency_initializer.dart';
import '../../core/loading_hud/loading_hud_cubit.dart';
import '../../util/utility.dart';
import '../shared/google_ad_mixin.dart';
import '../shared/widgets/alert_dialog_widget.dart';
import 'edit_form/ui/cubit/form_cubit.dart';
import 'settings/settings_tab.dart';
import 'top_panel.dart';

class FormTabPage extends StatefulWidget {
  final String formId;

  const FormTabPage({super.key, required this.formId});

  @override
  State<FormTabPage> createState() => _FormTabPageState();
}

class _FormTabPageState extends State<FormTabPage> with GoogleAdMixin {
  late FormCubit _formCubit;
  late LoadingHudCubit _loadingHudCubit;

  late StreamSubscription _formCubitSubscription;

  @override
  void initState() {
    super.initState();
    loadAd();
    _formCubit = sl<FormCubit>();
    _loadingHudCubit = sl<LoadingHudCubit>();
    _formCubit.fetchForm(widget.formId);
    _formCubitSubscription = _formCubit.stream.listen(_onListenFormCubit);
  }

  @override
  void dispose() {
    _formCubitSubscription.cancel();
    super.dispose();
  }

  void _onListenFormCubit(state) async {
    if (state is FormListUpdateState) {
      _loadingHudCubit.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Base(
        loadingHudCubit: _loadingHudCubit,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            titleSpacing: 0.0,
            title: const Text(
              'Edit form',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            backgroundColor: Colors.white,
            leading: Builder(
              builder: (context) {
                return _buildBackIcon(context);
              },
            ),
            actions: [_buildSubscriptionButton(context)],
          ),
          body: DefaultTabController(
            length: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTopPanel(),
                const Divider(height: 0),
                _buildTabBar(),
                _buildTabBarView(),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(children: [
        EditFormPage(
          formId: widget.formId,
          formCubit: _formCubit,
          loadingHudCubit: _loadingHudCubit,
        ),
        ResponsePage(formCubit: _formCubit),
        SettingsTab(
          formCubit: _formCubit,
          formId: widget.formId,
          loadingHudCubit: _loadingHudCubit,
        ),
      ]),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: BlocBuilder<FormCubit, EditFormState>(
        bloc: _formCubit,
        builder: (context, state) {
          return TabBar(
            indicator: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color(0xff6818B9), width: 3.0))),
            labelColor: const Color(0xff6818B9),
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: [
              const Tab(text: 'Questions'),
              Tab(child: _getResponseTabBarText(state)),
              const Tab(text: 'Settings'),
            ],
          );
        },
      ),
    );
  }

  Widget _getResponseTabBarText(EditFormState state) {
    final size = state is FormListUpdateState ? _formCubit.responseListSize : 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Responses'),
        if (size > 0) const Gap(4),
        if (size > 0)
          Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
                color: const Color(0xff6818B9),
                borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Text(
                size.toString(),
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          )
      ],
    );
  }

  Widget _buildTopPanel() {
    return TopPanel(
      onSaveButtonTap: () async {
        if (OnePref.getRemoveAds() ?? false) {
          _loadingHudCubit.show();
          _formCubit.submitRequest(widget.formId);
        } else {
          showAdCallback(() {
            _loadingHudCubit.show();
            _formCubit.submitRequest(widget.formId);
          });
        }
      },
      onShareButtonTap: () async {
        if (_formCubit.checkIfListIsEmpty()) {
          await shareForm(_formCubit.responderUrl);
        } else {
          _showSaveDialog('cancel');
        }
      },
      onPreviewButtonTap: () {
        _launchUrl();
      },
    );
  }

  Future<void> _showSaveDialog(String cancelText) async {
    await showDialog(
        useRootNavigator: false,
        context: context,
        builder: (_) {
          return confirmationDialog(
            context: context,
            message:
                'Your progress is not saved yet. Do you want to save your progress?',
            onTapContinueButton: () {
              Navigator.of(context).pop();
              _loadingHudCubit.show();
              _formCubit.submitRequest(widget.formId, fromShare: true);
            },
            onTapCancelButton: () {
              Navigator.pop(context);
              if (cancelText == 'exit') {
                Navigator.pop(context);
              }
            },
            cancelText: cancelText,
          );
        });
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(_formCubit.responderUrl))) {
      throw Exception('Could not launch url');
    }
  }
}
