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
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check,
                          size: 20,
                          color: Colors.white,
                        ),
                        Text('Save', style: TextStyle(color: Colors.white),)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
