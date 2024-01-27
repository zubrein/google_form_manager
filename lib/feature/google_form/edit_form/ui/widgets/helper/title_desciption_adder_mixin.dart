import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';
import 'package:google_form_manager/util/utility.dart';
import 'package:googleapis/forms/v1.dart';

import '../../cubit/form_cubit.dart';
import '../shared/edit_text_widget.dart';

mixin TitleDescriptionAdderMixin {
  int get widgetIndex;

  Item? get widgetItem;

  OperationType get operationType;

  FormCubit get formCubit;

  Set<String> get titleDescUpdateMask;

  Request get titleDescRequest;

  Duration debounceDuration = const Duration(milliseconds: 500);

  final TextEditingController questionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Widget buildEditTitleWidget({String hint = 'Question', bool enabled = true}) {
    return EditTextWidget(
      controller: questionController,
      fontSize: 18,
      fontColor: Colors.black,
      fontWeight: FontWeight.w700,
      onChange: _onChangeTitleText,
      hint: hint,
      enabled: enabled,
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
      titleDescAddRequest(debounceTag: titleDebounceTag);
    } else if (operationType == OperationType.create) {
      titleDescRequest.createItem?.item?.title = widgetItem?.title;
      titleDescAddRequest(debounceTag: titleDebounceTag);
    }
  }

  Widget buildEditDescriptionWidget({
    String description = 'Description',
    bool enabled = true,
    bool isCaption = false,
  }) {
    return EditTextWidget(
      controller: descriptionController,
      onChange: isCaption ? _onChangeCaptionText : _onChangeDescriptionText,
      hint: description,
      enabled: enabled,
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
      titleDescAddRequest(debounceTag: descriptionDebounceTag);
    } else if (operationType == OperationType.create) {
      titleDescRequest.createItem?.item?.description = widgetItem?.description;
      titleDescAddRequest(debounceTag: descriptionDebounceTag);
    }
  }

  void _onChangeCaptionText(String value) {
    var descriptionDebounceTag = '$widgetIndex caption';
    widgetItem?.videoItem?.caption = value;

    if (operationType == OperationType.update) {
      titleDescRequest.updateItem?.item?.videoItem?.caption =
          widgetItem?.videoItem?.caption;
      titleDescUpdateMask.add(Constants.caption);
      titleDescRequest.updateItem?.updateMask =
          updateMaskBuilder(titleDescUpdateMask);
      titleDescAddRequest(debounceTag: descriptionDebounceTag);
    } else if (operationType == OperationType.create) {
      titleDescRequest.createItem?.item?.videoItem?.caption =
          widgetItem?.videoItem?.caption;
      titleDescAddRequest(debounceTag: descriptionDebounceTag);
    }
  }

  void titleDescAddRequest({String? debounceTag}) {
    if (debounceTag != null) {
      EasyDebounce.debounce(debounceTag, debounceDuration, () {
        formCubit.addOtherRequest(titleDescRequest, widgetIndex);
      });
    } else {
      formCubit.addOtherRequest(titleDescRequest, widgetIndex);
    }
  }
}
