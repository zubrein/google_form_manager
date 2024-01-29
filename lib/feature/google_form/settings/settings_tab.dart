import 'package:flutter/material.dart';

import '../edit_form/ui/cubit/form_cubit.dart';
import '../edit_form/ui/widgets/shared/switch_widget.dart';

class SettingsTab extends StatefulWidget {
  final FormCubit formCubit;

  const SettingsTab({super.key, required this.formCubit});

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
                    onToggle: (bool val) {},
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
}
