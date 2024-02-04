import 'package:flutter/material.dart';

import '../../../core/loading_hud/loading_hud_cubit.dart';
import '../../shared/widgets/alert_dialog_widget.dart';
import '../edit_form/ui/cubit/form_cubit.dart';
import '../edit_form/ui/widgets/shared/switch_widget.dart';

class SettingsTab extends StatefulWidget {
  final FormCubit formCubit;
  final String formId;

  final LoadingHudCubit loadingHudCubit;

  const SettingsTab(
      {super.key,
      required this.formCubit,
      required this.formId,
      required this.loadingHudCubit});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Make this a quiz',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SwitchWidget(
                    onToggle: (bool val) {
                      _showAlertDialog(val);
                    },
                    isRequired: widget.formCubit.isQuiz,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAlertDialog(bool toggle) async {
    await showDialog(
        useRootNavigator: false,
        context: context,
        builder: (_) {
          return confirmationDialog(
            context: context,
            message:
                'Your changes will be removed? Do you want to change the settings?',
            onTapContinueButton: () async {
              Navigator.of(context).pop();
              widget.loadingHudCubit.show();
              await widget.formCubit.changeQuizSettings(toggle, widget.formId);
              // pop();
            },
            onTapCancelButton: () {
              Navigator.pop(context);
            },
            cancelText: 'Cancel',
          );
        });
  }

  void pop() {
    Navigator.pop(context);
  }
}
