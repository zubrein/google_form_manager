import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';

class BaseItemEntity {
  final Item? item;
  final OperationType opType;
  bool visibility;

  BaseItemEntity({
    required this.item,
    required this.opType,
    required this.visibility,
  });
}
