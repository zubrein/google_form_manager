import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/feature/edit_form/domain/constants.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:google_form_manager/feature/edit_form/ui/cubit/edit_form_cubit.dart';
import 'package:googleapis/forms/v1.dart';

import '../../cubit/batch_update_cubit.dart';
import '../shared/base_item_widget.dart';
import 'create_request_item_helper.dart';
import 'delete_request_item_helper.dart';
import 'update_request_item_helper.dart';

mixin RequestBuilderHelper<T extends StatefulWidget> on State<T> {
  int get widgetIndex;

  QuestionType get questionType;

  OperationType get operationType;

  Duration debounceDuration = const Duration(milliseconds: 500);

  bool? get isRequired;

  final Set<String> updateMask = {};

  Widget body();

  late Request request;
  late BatchUpdateCubit _batchUpdateCubit;
  late EditFormCubit _editFormCubit;

  @override
  void initState() {
    super.initState();
    _batchUpdateCubit = sl<BatchUpdateCubit>();
    _editFormCubit = BlocProvider.of<EditFormCubit>(context);
    request = prepareInitialRequest();
    if (operationType == OperationType.create) addRequest();
    init();
  }

  void init();

  @override
  Widget build(BuildContext context) {
    return BaseItemWidget(
      questionType: questionType,
      onRequiredSwitchToggle: (value) {
        updateMask.add(Constants.required);
        request.updateItem?.updateMask = updateMaskBuilder(updateMask);
        request.updateItem?.item?.questionItem?.question?.required = value;
        addRequest();
      },
      isRequired: isRequired,
      onDelete: () {
        _editFormCubit.deleteItem(widgetIndex);
        _batchUpdateCubit.addRequest(
          DeleteRequestItemHelper.createDeleteRequest(widgetIndex),
          widgetIndex,
        );
      },
      childWidget: body(),
    );
  }

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
        _batchUpdateCubit.addRequest(request, widgetIndex);
      });
    } else {
      _batchUpdateCubit.addRequest(request, widgetIndex);
    }
  }
}
