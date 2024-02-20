import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TemplateButton extends StatelessWidget {
  final String buttonName;
  final String buttonImage;
  final Function() buttonOnClick;

  const TemplateButton({
    super.key,
    required this.buttonName,
    required this.buttonImage,
    required this.buttonOnClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonOnClick,
      child: SizedBox(
        height: 100,
        width: 100,
        child: Column(
          children: [
            SizedBox(
              height: 70,
              width: 70,
              child: Image.asset(
                buttonImage,
              ),
            ),
            const Gap(8),
            Text(
              buttonName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
