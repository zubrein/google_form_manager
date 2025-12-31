import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/shared/google_ad_mixin.dart';
import 'package:onepref/onepref.dart';
// import 'package:url_launcher/url_launcher.dart';

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

class _SettingsTabState extends State<SettingsTab> with GoogleAdMixin {
  @override
  void initState() {
    super.initState();
    loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'General',
                style: TextStyle(
                  color: Color(0xff6818B9),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Gap(16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Make this a quiz',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Divider(),
              ),
              const Text(
                'Response',
                style: TextStyle(
                  color: Color(0xff6818B9),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Gap(16),
              GestureDetector(
                onTap: () async {
                  if (OnePref.getRemoveAds() ?? false) {
                    await _onSaveResponseButtonTapped(context);
                  } else {
                    showAdCallback(() async {
                      await _onSaveResponseButtonTapped(context);
                    });
                  }
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (!(OnePref.getRemoveAds() ?? false))
                          Image.asset(
                            'assets/app_image/subscription_logo.png',
                            height: 24,
                            width: 24,
                          ),
                        const Gap(16),
                        const Expanded(
                          child: Text(
                            'Save response to google sheet',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        if ((OnePref.getRemoveAds() ?? false))
                          _buildPurchaseButton(),
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(8),
              GestureDetector(
                onTap: () async {
                  if (OnePref.getRemoveAds() ?? false) {
                    await _onGoToSheetButtonTap(context);
                  } else {
                    showAdCallback(() async {
                      await _onGoToSheetButtonTap(context);
                    });
                  }
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (!(OnePref.getRemoveAds() ?? false))
                        Image.asset(
                          'assets/app_image/subscription_logo.png',
                          height: 24,
                          width: 24,
                        ),
                        const Gap(16),
                        const Expanded(
                          child: Text(
                            'Go To google sheet',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        if ((OnePref.getRemoveAds() ?? false))
                          _buildPurchaseButton(),
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(8),
            ],
          ),
        ));
  }

  Widget _buildPurchaseButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(4),
      ),
      height: 25,
      width: 50,
      child: const Center(
          child: Text(
        'Purchased',
        style: TextStyle(color: Colors.white, fontSize: 10),
      )),
    );
  }

  Future<void> _onGoToSheetButtonTap(BuildContext context) async {
    widget.loadingHudCubit.show();
    await widget.formCubit.sheetUrl(widget.formId).then((sheetId) {
      widget.loadingHudCubit.cancel();
      if (sheetId.isNotEmpty) {
        _launchUrl(sheetId);
      } else {
        widget.loadingHudCubit.cancel();
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: Text(
                  'Please save your response first.',
                  textAlign: TextAlign.center,
                ),
              );
            });
      }
    });
  }

  Future<void> _onSaveResponseButtonTapped(BuildContext context) async {
    widget.loadingHudCubit.show();
    await widget.formCubit.saveToSheet(widget.formId).then((value) {
      widget.loadingHudCubit.cancel();
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                'Data saved to google sheet successfully',
                textAlign: TextAlign.center,
              ),
            );
          });
    });
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

  Future<void> _launchUrl(String sheetId) async {
    // if (!await launchUrl(
    //     Uri.parse('https://docs.google.com/spreadsheets/d/$sheetId'))) {
    //   throw Exception('Could not launch url');
    // }
  }
}
