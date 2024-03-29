import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';

import '../../cubit/form_cubit.dart';
import '../shared/base_item_widget.dart';
import 'create_request_item_helper.dart';
import 'update_request_item_helper.dart';

mixin RequestBuilderHelper<T extends StatefulWidget> on State<T> {
  int get widgetIndex;

  QuestionType get questionType;

  OperationType get operationType;

  Duration debounceDuration = const Duration(milliseconds: 500);

  bool? get isRequired;

  VoidCallback get onTapMenuButton;

  VoidCallback? get onAnswerKeyPressed;

  FormCubit get formCubit;

  final Set<String> updateMask = {};

  Widget body();

  late Request request;

  bool showDescription = false;

  bool isQuiz = false;

  @override
  void initState() {
    super.initState();
    request = prepareInitialRequest(
      operationType: operationType,
      questionType: questionType,
      index: widgetIndex,
      isQuiz: formCubit.isQuiz,
    );
    init();
  }

  void init();

  static Request prepareInitialRequest({
    required OperationType operationType,
    required QuestionType questionType,
    required int index,
    required bool isQuiz,
  }) {
    switch (operationType) {
      case OperationType.update:
        return UpdateRequestItemHelper.prepareUpdateRequest(
            questionType, index);
      case OperationType.create:
        return isQuiz
            ? CreateRequestItemHelper.prepareCreateRequestWithGrading(
                questionType, index)
            : CreateRequestItemHelper.prepareCreateRequest(questionType, index);
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
        formCubit.addOtherRequest(request, widgetIndex);
      });
    } else {
      formCubit.addOtherRequest(request, widgetIndex);
    }
  }

  void onDeleteButtonTap() {
    formCubit.deleteItem(widgetIndex);
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

  Widget baseWidget() {
    isQuiz = formCubit.isQuiz;
    return BaseItemWidget(
      questionType: questionType,
      onRequiredSwitchToggle: onRequiredButtonToggle,
      isRequired: isRequired,
      onDelete: onDeleteButtonTap,
      onTapMenuButton: onTapMenuButton,
      onAnswerKeyPressed: onAnswerKeyPressed,
      isQuiz: isQuiz,
      childWidget: body(),
    );
  }
}
