import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Widget confirmationDialog({
  required BuildContext context,
  required String message,
  VoidCallback? onTapCancelButton,
  VoidCallback? onTapContinueButton,
  String? cancelText,
}) {
  return CupertinoAlertDialog(
    content: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Gap(16),
        Text(message),
        const Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: onTapCancelButton,
                child: Text(
                  cancelText ?? 'cancel',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                )),
            TextButton(
                onPressed: onTapContinueButton ??
                    () {
                      Navigator.of(context).pop();
                    },
                child: const Text(
                  'continue',
                  style: TextStyle(fontWeight: FontWeight.w700),
                )),
          ],
        )
      ],
    ),
  );
}
