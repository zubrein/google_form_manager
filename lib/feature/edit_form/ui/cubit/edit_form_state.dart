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
  final List<Item> items;

  const FormListUpdateState(this.items);

  @override
  List<Object?> get props => [];
}

class FetchFormFailedState extends EditFormState {
  @override
  List<Object?> get props => [];
}

class BatchInitiatedState extends EditFormState {
  @override
  List<Object?> get props => [];
}

class BatchSuccessState extends EditFormState {
  final bool isFormUpdated;

  const BatchSuccessState(this.isFormUpdated);

  @override
  List<Object?> get props => [];
}

class BatchFailedState extends EditFormState {
  @override
  List<Object?> get props => [];
}
