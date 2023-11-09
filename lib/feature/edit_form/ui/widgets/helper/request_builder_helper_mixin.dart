import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';

import '../../cubit/batch_update_cubit.dart';
import '../shared/base_item_widget.dart';
import 'update_request_builder_helper.dart';

mixin RequestBuilderHelper<T extends StatefulWidget> on State<T> {
  int get widgetIndex;

  QuestionType get questionType;

  OperationType get operationType;

  Duration debounceDuration = const Duration(milliseconds: 500);

  Widget body();

  late Request request;
  late BatchUpdateCubit _batchUpdateCubit;

  @override
  void initState() {
    super.initState();
    _batchUpdateCubit = sl<BatchUpdateCubit>();
    request = prepareInitialRequest();
    init();
  }

  void init();

  @override
  Widget build(BuildContext context) {
    return BaseItemWidget(
      questionType: questionType,
      childWidget: body(),
    );
  }

  Request prepareInitialRequest() {
    switch (operationType) {
      case OperationType.update:
        return prepareUpdateRequest();
      default:
        return Request();
    }
  }

  Request prepareUpdateRequest() {
    switch (questionType) {
      case QuestionType.shortAnswer:
        return UpdateRequestBuilderHelper.prepareShortAnswerUpdateRequest(
          widgetIndex,
        );
      case QuestionType.paragraph:
        return UpdateRequestBuilderHelper.prepareShortAnswerUpdateRequest(
            widgetIndex,
            isParagraph: true);
      default:
        return Request();
    }
  }

  String updateMaskBuilder(Set updateMask) {
    return updateMask.isNotEmpty
        ? updateMask.toString().replaceAll(RegExp(r'[ {}]'), '')
        : '';
  }

  void addRequest(String debounceTag) {
    EasyDebounce.debounce(debounceTag, debounceDuration, () {
      _batchUpdateCubit.addRequest(request, widgetIndex);
    });
  }
}
