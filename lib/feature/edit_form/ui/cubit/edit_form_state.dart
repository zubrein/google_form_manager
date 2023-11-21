part of 'edit_form_cubit.dart';

abstract class EditFormState extends Equatable {
  const EditFormState();
}

class EditFormInitial extends EditFormState {
  @override
  List<Object> get props => [];
}

class FetchFormInitiatedState extends EditFormState {
  @override
  List<Object?> get props => [];
}

class FormListUpdateState extends EditFormState {
  final List<BaseItemEntity> baseItem;

  const FormListUpdateState(this.baseItem);

  @override
  List<Object?> get props => [baseItem, DateTime.now()];
}

class FetchFormFailedState extends EditFormState {
  @override
  List<Object?> get props => [];
}

class FormSubmitFailedState extends EditFormState {
  final String error;
  final DateTime datetime = DateTime.now();

  FormSubmitFailedState(this.error);

  @override
  List<Object?> get props => [error, datetime];
}

class FormSubmitSuccessState extends EditFormState {
  const FormSubmitSuccessState();

  @override
  List<Object?> get props => [DateTime.now()];
}
