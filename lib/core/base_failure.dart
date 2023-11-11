import 'package:equatable/equatable.dart';

class BaseFailure extends Equatable {
  final String message;

  const BaseFailure(this.message);

  @override
  List<Object?> get props => [message];
}
