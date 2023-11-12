import 'package:flutter/material.dart';
import 'package:google_form_manager/feature/edit_form/ui/cubit/edit_form_cubit.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/multiple_choice/multiple_choice_widget.dart';
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

  Widget _buildMultipleChoiceWidget(
      int position, Item? qItem, OperationType oType, QuestionType qType) {
    return MultipleChoiceWidget(
      index: position,
      item: qItem,
      operationType: oType,
      editFormCubit: editFormCubit,
      type: qType,
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
      case QuestionType.multipleChoice:
        return _buildMultipleChoiceWidget(
            index, item, opType, QuestionType.multipleChoice);
      case QuestionType.checkboxes:
        return _buildMultipleChoiceWidget(
            index, item, opType, QuestionType.checkboxes);
      case QuestionType.dropdown:
        return _buildMultipleChoiceWidget(
            index, item, opType, QuestionType.dropdown);

      default:
        return Container(
          height: 60,
          color: Colors.red,
        );
    }
  }
}
