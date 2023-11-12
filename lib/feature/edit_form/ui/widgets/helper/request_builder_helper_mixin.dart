import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/cubit/edit_form_cubit.dart';
import 'package:googleapis/forms/v1.dart';

import '../../cubit/batch_update_cubit.dart';
import '../shared/base_item_widget.dart';
import 'create_request_item_helper.dart';
import 'update_request_item_helper.dart';

mixin RequestBuilderHelper<T extends StatefulWidget> on State<T> {
  int get widgetIndex;

  QuestionType get questionType;

  OperationType get operationType;

  Duration debounceDuration = const Duration(milliseconds: 500);

  bool? get isRequired;

  EditFormCubit get editFormCubit;

  final Set<String> updateMask = {};

  Widget body();

  late Request request;
  late BatchUpdateCubit _batchUpdateCubit;

  @override
  void initState() {
    super.initState();
    _batchUpdateCubit = sl<BatchUpdateCubit>();
    request = prepareInitialRequest();
    if (operationType == OperationType.create) addRequest();
    init();
  }

  void init();

  Request prepareInitialRequest() {
    switch (operationType) {
      case OperationType.update:
        return prepareUpdateRequest();
      case OperationType.create:
        return prepareCreateRequest();
      default:
        return Request();
    }
  }

  Request prepareUpdateRequest() {
    switch (questionType) {
      case QuestionType.shortAnswer:
        return UpdateRequestItemHelper.prepareShortAnswerUpdateRequest(
          widgetIndex,
        );
      case QuestionType.paragraph:
        return UpdateRequestItemHelper.prepareShortAnswerUpdateRequest(
            widgetIndex,
            isParagraph: true);
      case QuestionType.multipleChoice:
        return UpdateRequestItemHelper.prepareMultipleChoiceUpdateRequest(
            widgetIndex,
            type: QuestionType.multipleChoice);
      case QuestionType.checkboxes:
        return UpdateRequestItemHelper.prepareMultipleChoiceUpdateRequest(
            widgetIndex,
            type: QuestionType.checkboxes);
      case QuestionType.dropdown:
        return UpdateRequestItemHelper.prepareMultipleChoiceUpdateRequest(
            widgetIndex,
            type: QuestionType.dropdown);

      default:
        return Request();
    }
  }

  Request prepareCreateRequest() {
    switch (questionType) {
      case QuestionType.shortAnswer:
        return CreateRequestItemHelper.prepareShortAnswerCreateRequest(
          widgetIndex,
        );
      case QuestionType.paragraph:
        return CreateRequestItemHelper.prepareShortAnswerCreateRequest(
            widgetIndex,
            isParagraph: true);
      case QuestionType.multipleChoice:
        return CreateRequestItemHelper.prepareMultipleChoiceCreateRequest(
            widgetIndex,
            type: QuestionType.multipleChoice);
      case QuestionType.checkboxes:
        return CreateRequestItemHelper.prepareMultipleChoiceCreateRequest(
            widgetIndex,
            type: QuestionType.checkboxes);
      case QuestionType.dropdown:
        return CreateRequestItemHelper.prepareMultipleChoiceCreateRequest(
            widgetIndex,
            type: QuestionType.dropdown);

      default:
        return Request();
    }
  }

  String updateMaskBuilder(Set updateMask) {
    return updateMask.isNotEmpty
        ? updateMask.toString().replaceAll(RegExp(r'[ {}]'), '')
        : '';
  }

  void addRequest({String? debounceTag}) {
    if (debounceTag != null) {
      EasyDebounce.debounce(debounceTag, debounceDuration, () {
        _batchUpdateCubit.addOtherRequest(request, widgetIndex);
      });
    } else {
      _batchUpdateCubit.addOtherRequest(request, widgetIndex);
    }
  }

  void onDeleteButtonTap() {
    editFormCubit.deleteItem(widgetIndex);
    _batchUpdateCubit.addDeleteRequest(widgetIndex);
  }

  void onRequiredButtonToggle(value) {
    if (operationType == OperationType.update) {
      updateMask.add(Constants.required);
      request.updateItem?.updateMask = updateMaskBuilder(updateMask);
      request.updateItem?.item?.questionItem?.question?.required = value;
    } else if (operationType == OperationType.create) {
      request.createItem?.item?.questionItem?.question?.required = value;
    }
    addRequest();
  }

  Widget baseWidget() => BaseItemWidget(
        questionType: questionType,
        onRequiredSwitchToggle: onRequiredButtonToggle,
        isRequired: isRequired,
        onDelete: onDeleteButtonTap,
        childWidget: body(),
      );
}
