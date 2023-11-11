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

class ItemDeletedState extends EditFormState {
  @override
  List<Object?> get props => [DateTime.now()];
}
