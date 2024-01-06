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

class ShowTitleState extends EditFormState {
  final String title;
  final String description;

  const ShowTitleState(this.title, this.description);

  @override
  List<Object?> get props => [title, description, DateTime.now()];
}

class FetchFormFailedState extends EditFormState {
  @override
  List<Object?> get props => [];
}

class FormSubmitFailedState extends EditFormState {
  final String error;
  final bool fromShare;
  final DateTime datetime = DateTime.now();

  FormSubmitFailedState(this.error, this.fromShare);

  @override
  List<Object?> get props => [error, fromShare, datetime];
}

class FormSubmitSuccessState extends EditFormState {
  final bool fromShare;

  const FormSubmitSuccessState(this.fromShare);

  @override
  List<Object?> get props => [fromShare, DateTime.now()];
}
