import 'package:flutter/material.dart';

class TemplateButton extends StatelessWidget {
  final String buttonName;
  final String buttonImage;
  final Widget? addButton;
  final Function() buttonOnClick;

  const TemplateButton({
    super.key,
    required this.buttonName,
    required this.buttonImage,
    required this.buttonOnClick,
    this.addButton,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonOnClick,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              Expanded(
                child: ColoredBox(
                  color: const Color(0xffEFEBF9),
                  child: addButton ??
                      Image.asset(
                        buttonImage,
                        fit: BoxFit.fill,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  buttonName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
