import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/base.dart';
import 'package:google_form_manager/feature/google_form/edit_form/ui/edit_form_page.dart';
import 'package:google_form_manager/feature/google_form/responses/response_page.dart';

import '../../core/di/dependency_initializer.dart';
import '../../core/loading_hud/loading_hud_cubit.dart';
import '../../util/utility.dart';
import '../shared/widgets/alert_dialog_widget.dart';
import 'edit_form/ui/cubit/form_cubit.dart';
import 'top_panel.dart';

class FormTabPage extends StatefulWidget {
  final String formId;

  const FormTabPage({super.key, required this.formId});

  @override
  State<FormTabPage> createState() => _FormTabPageState();
}

class _FormTabPageState extends State<FormTabPage> {
  late FormCubit _formCubit;
  late LoadingHudCubit _loadingHudCubit;

  late StreamSubscription _formCubitSubscription;

  @override
  void initState() {
    super.initState();
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
          body: DefaultTabController(
            length: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopPanel(),
                _buildTabBar(),
                _buildTabBarView(),
              ],
            ),
          ),
        ),
      ),
    );
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
        const Center(child: Text('Settings')),
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
                    bottom: BorderSide(color: Colors.black, width: 2.0))),
            labelColor: Colors.black,
            padding: EdgeInsets.zero,
            indicatorPadding: EdgeInsets.zero,
            labelPadding: const EdgeInsets.only(right: 16),
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
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
      children: [
        const Text('Responses'),
        if (size > 0) const Gap(4),
        if (size > 0)
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
                color: Colors.black54, borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Text(
                size.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
      ],
    );
  }

  Widget _buildTopPanel() {
    return TopPanel(
      onSaveButtonTap: () async {
        _loadingHudCubit.show();
        _formCubit.submitRequest(widget.formId);
      },
      onShareButtonTap: () async {
        if (_formCubit.checkIfListIsEmpty()) {
          await shareForm(_formCubit.responderUrl);
        } else {
          _showSaveDialog('cancel');
        }
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
}
