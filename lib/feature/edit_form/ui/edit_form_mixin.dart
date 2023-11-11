import 'package:flutter/material.dart';
import 'package:google_form_manager/feature/edit_form/ui/cubit/edit_form_cubit.dart';
import 'package:googleapis/forms/v1.dart';

import '../domain/enums.dart';
import 'widgets/short_answer/short_answer_widget.dart';

mixin EditFormMixin {
  EditFormCubit get editFormCubit;

  Widget _buildShortAnswerWidget(int position, Item? qItem, OperationType type,
      {bool isParagraph = false}) {
    return ShortAnswerWidget(
      index: position,
      item: qItem,
      operationType: type,
      editFormCubit: editFormCubit,
      isParagraph: isParagraph,
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
        return Container(
          height: 60,
          color: Colors.red,
        );
    }
  }
}
