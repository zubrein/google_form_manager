import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/cubit/edit_form_cubit.dart';
import 'package:google_form_manager/util/utility.dart';
import 'package:googleapis/forms/v1.dart';

import '../shared/edit_text_widget.dart';

mixin TitleDescriptionAdderMixin {
  int get widgetIndex;

  Item? get widgetItem;

  OperationType get operationType;

  EditFormCubit get editFormCubit;

  Set<String> get titleDescUpdateMask;

  Request get titleDescRequest;

  Duration debounceDuration = const Duration(milliseconds: 500);

  final TextEditingController questionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Widget buildEditTitleWidget() {
    return EditTextWidget(
      controller: questionController,
      fontSize: 18,
      fontColor: Colors.black,
      fontWeight: FontWeight.w700,
      onChange: _onChangeTitleText,
      hint: 'Question',
    );
  }

  void _onChangeTitleText(String value) {
    String titleDebounceTag = '$widgetIndex title';
    widgetItem?.title = value;
    if (operationType == OperationType.update) {
      titleDescRequest.updateItem?.item?.title = widgetItem?.title;
      titleDescUpdateMask.add(Constants.title);
      titleDescRequest.updateItem?.updateMask =
          updateMaskBuilder(titleDescUpdateMask);
      addRequest(debounceTag: titleDebounceTag);
    } else if (operationType == OperationType.create) {
      titleDescRequest.createItem?.item?.title = widgetItem?.title;
      addRequest(debounceTag: titleDebounceTag);
    }
  }

  Widget buildEditDescriptionWidget() {
    return EditTextWidget(
      controller: descriptionController,
      onChange: _onChangeDescriptionText,
      hint: 'Description',
    );
  }

  void _onChangeDescriptionText(String value) {
    var descriptionDebounceTag = '$widgetIndex description';
    widgetItem?.description = value;

    if (operationType == OperationType.update) {
      titleDescRequest.updateItem?.item?.description = widgetItem?.description;
      titleDescUpdateMask.add(Constants.description);
      titleDescRequest.updateItem?.updateMask =
          updateMaskBuilder(titleDescUpdateMask);
      addRequest(debounceTag: descriptionDebounceTag);
    } else if (operationType == OperationType.create) {
      titleDescRequest.createItem?.item?.description = widgetItem?.description;
      addRequest(debounceTag: descriptionDebounceTag);
    }
  }

  void addRequest({String? debounceTag}) {
    if (debounceTag != null) {
      EasyDebounce.debounce(debounceTag, debounceDuration, () {
        editFormCubit.addOtherRequest(titleDescRequest, widgetIndex);
      });
    } else {
      editFormCubit.addOtherRequest(titleDescRequest, widgetIndex);
    }
  }
}