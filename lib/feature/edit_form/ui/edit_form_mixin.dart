import 'package:flutter/material.dart';
import 'package:googleapis/forms/v1.dart';

import '../domain/enums.dart';
import 'widgets/short_answer/short_answer_widget.dart';

mixin EditFormMixin {
  Widget _buildShortAnswerWidget(int position, Item? qItem, OperationType type,
      {bool isParagraph = false}) {
    return ShortAnswerWidget(
      index: position,
      item: qItem,
      operationType: type,
    );
  }

  Widget buildFormItem(
      {required QuestionType qType,
      required Item? item,
      required int index,
      required OperationType opType}) {
    switch (qType) {
      case QuestionType.shortAnswer:
        return _buildShortAnswerWidget(index, item, opType);
      case QuestionType.paragraph:
        return _buildShortAnswerWidget(index, item, opType, isParagraph: true);
      default:
        return const SizedBox.shrink();
    }
  }
}
