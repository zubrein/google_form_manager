import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SwitchWidget extends StatefulWidget {
  const SwitchWidget({super.key});

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  bool status = false;

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      activeColor: Colors.green,
      width: 30.0,
      height: 16.0,
      toggleSize: 12.0,
      value: status,
      borderRadius: 8.0,
      padding: 2.0,
      showOnOff: false,
      onToggle: (val) {
        setState(() {
          status = val;
        });
      },
    );
  }
}
