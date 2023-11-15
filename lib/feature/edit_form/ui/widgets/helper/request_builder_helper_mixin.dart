import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/cubit/edit_form_cubit.dart';
import 'package:googleapis/forms/v1.dart';

import '../../../../../core/helper/logger.dart';
import '../shared/base_item_widget.dart';
import 'create_request_item_helper.dart';

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

  @override
  void initState() {
    super.initState();
    request = CreateRequestItemHelper.prepareInitialRequest(
        operationType: operationType,
        questionType: questionType,
        index: widgetIndex);
    Log.info('create req added');
    init();
  }

  void init();

  String updateMaskBuilder(Set updateMask) {
    return updateMask.isNotEmpty
        ? updateMask.toString().replaceAll(RegExp(r'[ {}]'), '')
        : '';
  }

  void addRequest({String? debounceTag}) {
    if (debounceTag != null) {
      EasyDebounce.debounce(debounceTag, debounceDuration, () {
        editFormCubit.addOtherRequest(request, widgetIndex);
      });
    } else {
      editFormCubit.addOtherRequest(request, widgetIndex);
    }
  }

  void onDeleteButtonTap() {
    editFormCubit.deleteItem(widgetIndex);
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
