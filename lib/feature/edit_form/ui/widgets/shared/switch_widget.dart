import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SwitchWidget extends StatefulWidget {
  final bool? isRequired;
  final void Function(bool val) onToggle;

  const SwitchWidget({super.key, this.isRequired, required this.onToggle});

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  bool status = false;

  @override
  void initState() {
    super.initState();
    status = widget.isRequired ?? false;
  }

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
        widget.onToggle(val);
      },
    );
  }
}
