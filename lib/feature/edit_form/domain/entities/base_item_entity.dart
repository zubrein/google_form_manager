import 'package:equatable/equatable.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';

class BaseItemEntity extends Equatable {
  final Item? item;
  final OperationType opType;

  const BaseItemEntity(this.item, this.opType);

  @override
  List<Object?> get props => [opType];
}
