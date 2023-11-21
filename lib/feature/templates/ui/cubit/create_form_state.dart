part of 'create_form_cubit.dart';

abstract class CreateFormState extends Equatable {
  const CreateFormState();
}

class CreateFormInitial extends CreateFormState {
  @override
  List<Object> get props => [];
}

class CreateFormInitiatedState extends CreateFormState {
  @override
  List<Object> get props => [];
}

class CreateFormSuccessState extends CreateFormState {
  @override
  List<Object> get props => [];
}

class CreateFormFailedState extends CreateFormState {
  final String error;

  const CreateFormFailedState(this.error);

  @override
  List<Object> get props => [error, DateTime.now()];
}
