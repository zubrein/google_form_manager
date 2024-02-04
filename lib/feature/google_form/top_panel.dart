import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TopPanel extends StatelessWidget {
  final VoidCallback onSaveButtonTap;
  final VoidCallback onShareButtonTap;
  final VoidCallback onPreviewButtonTap;

  const TopPanel({
    super.key,
    required this.onSaveButtonTap,
    required this.onShareButtonTap,
    required this.onPreviewButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildBackArrow(context),
            _buildFormLogo(),
            const Expanded(child: SizedBox.shrink()),
            _buildPreviewButton(),
            _buildShareButton(),
            const Gap(8),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackArrow(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.maybePop(context);
        },
        icon: const Icon(
          Icons.arrow_back,
          size: 24,
        ));
  }

  Widget _buildFormLogo() {
    return Image.asset(
      'assets/google_form_logo.png',
      height: 24,
    );
  }

  GestureDetector _buildPreviewButton() {
    return GestureDetector(
      onTap: onPreviewButtonTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(4)),
        child: const Padding(
          padding: EdgeInsets.only(top: 4, right: 8),
          child: Icon(
            Icons.remove_red_eye_outlined,
            size: 24,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  GestureDetector _buildShareButton() {
    return GestureDetector(
      onTap: onShareButtonTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(4)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Icon(
            Icons.ios_share_outlined,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  GestureDetector _buildSaveButton() {
    return GestureDetector(
      onTap: onSaveButtonTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(8.0)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Row(
            children: [
              Icon(
                Icons.check,
                size: 20,
                color: Colors.white,
              ),
              Text(
                'Save',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
