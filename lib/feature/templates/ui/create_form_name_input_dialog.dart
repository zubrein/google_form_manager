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
      title: Text('Please enter ${widget.isQuiz ? 'quiz' : 'form'} name'),
      content: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
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
                      hintText:
                          'Please enter ${widget.isQuiz ? 'quiz' : 'form'} name',
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
            ),
            const Gap(16),
            GestureDetector(
                onTap: () {
                  if (buttonEnabled) {
                    Navigator.of(context).pop([_nameController.text]);
                  }
                },
                child: const Icon(Icons.arrow_forward))
          ],
        ),
      ),
    );
  }
}
