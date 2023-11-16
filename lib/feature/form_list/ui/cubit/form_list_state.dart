part of 'form_list_cubit.dart';

abstract class FormListState extends Equatable {
  const FormListState();
}

class FormListInitial extends FormListState {
  @override
  List<Object> get props => [];
}

class FormListFetchInitiatedState extends FormListState {
  @override
  List<Object?> get props => [];
}

class FormListFetchSuccessState extends FormListState {
  final List<File> formList;

  const FormListFetchSuccessState(this.formList);

  @override
  List<Object?> get props => [formList];
}

class FormDeleteInitiatedState extends FormListState {
  const FormDeleteInitiatedState();

  @override
  List<Object?> get props => [];
}
