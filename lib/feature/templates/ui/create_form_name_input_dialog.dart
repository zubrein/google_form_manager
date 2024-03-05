import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CreateFormNameInputDialog extends StatefulWidget {
  final bool isQuiz;

  const CreateFormNameInputDialog({super.key, this.isQuiz = false});

  @override
  State<CreateFormNameInputDialog> createState() =>
      _CreateFormNameInputDialogState();
}

class _CreateFormNameInputDialogState extends State<CreateFormNameInputDialog> {
  final TextEditingController _nameController = TextEditingController();
  bool buttonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      title: Text(
        'Please enter ${widget.isQuiz ? 'Quiz' : 'form'} name',
        style: const TextStyle(fontSize: 18),
      ),
      content: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                  color: const Color(0xffEBF2F7),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  cursorColor: const Color(0xff6818B9),
                  controller: _nameController,
                  autofocus: true,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 4,
                    ),
                    hintText: 'Enter ${widget.isQuiz ? 'quiz' : 'form'} name',
                    hintStyle: const TextStyle(color: Colors.black38),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        buttonEnabled = true;
                      } else {
                        buttonEnabled = false;
                      }
                    });
                  },
                ),
              ),
            ),
            const Gap(24),
            GestureDetector(
                onTap: () {
                  if (buttonEnabled) {
                    Navigator.of(context).pop([_nameController.text]);
                  }
                },
                child: Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color(0xff6818B9),
                      borderRadius: BorderRadius.circular(16)),
                  child: const Center(
                    child: Text(
                      'Create',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
