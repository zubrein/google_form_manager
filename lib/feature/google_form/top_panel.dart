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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTopPanelButton(
            image: 'assets/app_image/preview_icon.png',
            label: 'Preview',
            onTap: onPreviewButtonTap,
          ),
          _buildTopPanelButton(
            image: 'assets/app_image/share_icon.png',
            label: 'Share',
            onTap: onShareButtonTap,
          ),
          _buildTopPanelButton(
            image: 'assets/app_image/save_icon.png',
            label: 'Save',
            onTap: onSaveButtonTap,
          ),
        ],
      ),
    );
  }

  GestureDetector _buildTopPanelButton({
    required String image,
    required String label,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.only(top: 4, right: 8),
          child: Row(
            children: [
              Image.asset(
                image,
                height: label == 'Share' ? 18 : 24,
                width: label == 'Share' ? 18 : 24,
              ),
              const Gap(8),
              Text(
                label,
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
