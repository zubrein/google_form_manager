import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/shared/switch_widget.dart';

class ItemBottomWidget extends StatefulWidget {
  const ItemBottomWidget({super.key});

  @override
  State<ItemBottomWidget> createState() => _ItemBottomWidgetState();
}

class _ItemBottomWidgetState extends State<ItemBottomWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(Icons.delete_rounded, size: 22, color: Colors.black87),
          const Gap(8),
          _buildSwitchWidget(),
          const Gap(12),
          _menuIcon(),
        ],
      ),
    );
  }

  Row _buildSwitchWidget() {
    return const Row(children: [
      Text('Required'),
      Gap(4),
      SwitchWidget(),
    ]);
  }

  Widget _menuIcon() {
    List<Widget> menu = [];

    for (int i = 0; i < 3; i++) {
      menu.add(_buildMenuDot());
      menu.add(const Gap(2));
    }

    return Column(
      children: menu,
    );
  }

  DecoratedBox _buildMenuDot() {
    const size = 4.0;
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.black45),
      child: const SizedBox(
        height: size,
        width: size,
      ),
    );
  }
}