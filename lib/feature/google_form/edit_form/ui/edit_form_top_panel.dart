import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditFormTopPanel extends StatelessWidget {
  final VoidCallback onSaveButtonTap;
  final VoidCallback onShareButtonTap;

  const EditFormTopPanel({
    super.key,
    required this.onSaveButtonTap,
    required this.onShareButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.blueGrey,
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildSaveButton(),
              const Gap(8),
              _buildShareButton(),
            ],
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
          child: Row(
            children: [
              Icon(
                Icons.ios_share,
                size: 20,
                color: Colors.white,
              ),
              Text(
                'Share',
                style: TextStyle(color: Colors.white),
              )
            ],
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
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(4)),
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
