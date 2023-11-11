import 'package:flutter/material.dart';

class EditFormTopPanel extends StatelessWidget {
  final VoidCallback onSaveButtonTap;

  const EditFormTopPanel({super.key, required this.onSaveButtonTap});

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
              GestureDetector(
                onTap: onSaveButtonTap,
                child: const Icon(
                  Icons.check,
                  size: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
