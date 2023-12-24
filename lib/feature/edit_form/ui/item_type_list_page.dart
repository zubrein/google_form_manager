import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../domain/enums.dart';

class ItemTypeListPage extends StatefulWidget {
  final QuestionType? selectedType;

  const ItemTypeListPage({super.key, this.selectedType});

  @override
  State<ItemTypeListPage> createState() => _ItemTypeListPageState();
}

class _ItemTypeListPageState extends State<ItemTypeListPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop([widget.selectedType]);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Please select a type'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
              itemCount: questionTypeNameMap.keys.length - 4,
              itemBuilder: (context, position) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBottomSheetContent(
                        questionTypeNameMap.keys.toList()[position]),
                    _buildDivider(position),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget _buildDivider(int position) {
    return position == 1 || position == 4 || position == 7 || position == 9
        ? const Divider(
            color: Colors.black45,
          )
        : const SizedBox.shrink();
  }

  Widget _buildBottomSheetContent(QuestionType questionType) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop([questionType]);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  questionTypeIconMap[questionType],
                  size: 20,
                ),
                const Gap(8),
                Text(
                  questionTypeNameMap[questionType]!,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: widget.selectedType != null &&
                              widget.selectedType == questionType
                          ? FontWeight.w900
                          : FontWeight.w500),
                ),
              ],
            ),
            const Gap(8),
            widget.selectedType != null && widget.selectedType == questionType
                ? const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 18,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
