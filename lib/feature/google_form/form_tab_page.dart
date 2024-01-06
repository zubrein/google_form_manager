import 'package:flutter/material.dart';
import 'package:google_form_manager/base.dart';
import 'package:google_form_manager/feature/google_form/edit_form/ui/edit_form_page.dart';

import '../../core/di/dependency_initializer.dart';
import '../../core/loading_hud/loading_hud_cubit.dart';
import '../../util/utility.dart';
import '../shared/widgets/alert_dialog_widget.dart';
import 'edit_form/ui/cubit/edit_form_cubit.dart';
import 'top_panel.dart';

class FormTabPage extends StatefulWidget {
  final String formId;

  const FormTabPage({super.key, required this.formId});

  @override
  State<FormTabPage> createState() => _FormTabPageState();
}

class _FormTabPageState extends State<FormTabPage> {
  late EditFormCubit _editFormCubit;
  late LoadingHudCubit _loadingHudCubit;

  @override
  void initState() {
    super.initState();
    _editFormCubit = sl<EditFormCubit>();
    _loadingHudCubit = sl<LoadingHudCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Base(
        loadingHudCubit: _loadingHudCubit,
        child: Scaffold(
          body: DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopPanel(),
                const TabBar(
                  indicator: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black, width: 2.0))),
                  labelColor: Colors.black,
                  tabs: [
                    Tab(text: 'Questions'),
                    Tab(text: 'Responses'),
                  ],
                ),
                Expanded(
                  child: TabBarView(children: [
                    EditFormPage(
                      formId: widget.formId,
                      editFormCubit: _editFormCubit,
                      loadingHudCubit: _loadingHudCubit,
                    ),
                    const Center(child: Text('Responses')),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopPanel() {
    return TopPanel(
      onSaveButtonTap: () async {
        _loadingHudCubit.show();
        _editFormCubit.submitRequest(widget.formId);
      },
      onShareButtonTap: () async {
        if (_editFormCubit.checkIfListIsEmpty()) {
          await shareForm(_editFormCubit.responderUrl);
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
              _editFormCubit.submitRequest(widget.formId, fromShare: true);
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
