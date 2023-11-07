import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/create_form_usecase.dart';

part 'create_form_state.dart';

@injectable
class CreateFormCubit extends Cubit<CreateFormState> {
  CreateFormUseCase createFormUseCase;

  CreateFormCubit({required this.createFormUseCase})
      : super(CreateFormInitial());

  Future<void> createForm(String formName) async {
    emit(CreateFormInitiatedState());
    final isCreated = await createFormUseCase(formName);
    if(isCreated){
      emit(CreateFormSuccessState());
    }else{
      emit(CreateFormFailedState());
    }
  }
}
