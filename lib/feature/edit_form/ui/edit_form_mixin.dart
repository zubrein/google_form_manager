import 'package:flutter/material.dart';
import 'package:google_form_manager/feature/edit_form/ui/cubit/edit_form_cubit.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/image/image_item_widget.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/linear_scale/linear_scale_widget.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/multiple_choice/multiple_choice_widget.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/page_break/page_break_widget.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/text_item/text_item_widget.dart';
import 'package:google_form_manager/feature/edit_form/ui/widgets/time/time_widget.dart';
import 'package:googleapis/forms/v1.dart';

import '../domain/enums.dart';
import 'widgets/date/date_widget.dart';
import 'widgets/file_upload/file_upload_widget.dart';
import 'widgets/multiple_choice_grid/multiple_choice_grid_widget.dart';
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

  Widget _buildDateWidget(int position, Item? qItem, OperationType type) {
    return DateWidget(
      index: position,
      item: qItem,
      operationType: type,
      editFormCubit: editFormCubit,
    );
  }

  Widget _buildTimeWidget(int position, Item? qItem, OperationType type) {
    return TimeWidget(
      index: position,
      item: qItem,
      operationType: type,
      editFormCubit: editFormCubit,
    );
  }

  Widget _buildLinearScaleWidget(
      int position, Item? qItem, OperationType type) {
    return LinearScaleWidget(
      index: position,
      item: qItem,
      operationType: type,
      editFormCubit: editFormCubit,
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

  Widget _buildFileUploadWidget(int position, Item? qItem, OperationType type) {
    return FileUploadWidget(
      index: position,
      item: qItem,
      operationType: type,
      editFormCubit: editFormCubit,
    );
  }

  Widget _buildMultipleChoiceGridWidget(
      int position, Item? qItem, OperationType oType, QuestionType qType) {
    return MultipleChoiceGridWidget(
      index: position,
      item: qItem,
      operationType: oType,
      editFormCubit: editFormCubit,
      type: qType,
    );
  }

  Widget _buildImageItemWidget(int position, Item? qItem, OperationType type) {
    return ImageItemWidget(
      index: position,
      item: qItem,
      operationType: type,
      editFormCubit: editFormCubit,
    );
  }

  Widget _buildTextItemWidget(int position, Item? qItem, OperationType type) {
    return TextItemWidget(
      index: position,
      item: qItem,
      operationType: type,
      editFormCubit: editFormCubit,
    );
  }

  Widget _buildPageBreakWidget(int position, Item? qItem, OperationType type) {
    return PageBreakWidget(
      index: position,
      item: qItem,
      operationType: type,
      editFormCubit: editFormCubit,
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
      case QuestionType.fileUpload:
        return _buildFileUploadWidget(index, item, opType);
      case QuestionType.date:
        return _buildDateWidget(index, item, opType);
      case QuestionType.time:
        return _buildTimeWidget(index, item, opType);
      case QuestionType.linearScale:
        return _buildLinearScaleWidget(index, item, opType);
      case QuestionType.multipleChoiceGrid:
        return _buildMultipleChoiceGridWidget(
            index, item, opType, QuestionType.multipleChoiceGrid);
      case QuestionType.checkboxGrid:
        return _buildMultipleChoiceGridWidget(
            index, item, opType, QuestionType.checkboxGrid);
      case QuestionType.image:
        return _buildImageItemWidget(index, item, opType);
      case QuestionType.text:
        return _buildTextItemWidget(index, item, opType);
      case QuestionType.pageBreak:
        return _buildPageBreakWidget(index, item, opType);

      default:
        return const SizedBox.shrink();
    }
  }
}
