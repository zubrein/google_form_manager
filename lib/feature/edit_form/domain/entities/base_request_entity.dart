import 'package:equatable/equatable.dart';
import 'package:google_form_manager/feature/edit_form/domain/enums.dart';
import 'package:googleapis/forms/v1.dart';

class BaseRequestEntity extends Equatable {
  final Request? request;
  final OperationType type;

  const BaseRequestEntity(this.request, this.type);

  @override
  List<Object?> get props => [request];
}
