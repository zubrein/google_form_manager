import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';

class BaseItemEntity {
  final String? itemId;
  final Item? item;
  final OperationType opType;
  bool visibility;
  Request? request;

  BaseItemEntity({
    this.itemId,
    required this.item,
    required this.opType,
    required this.visibility,
    required this.request,
  });
}
