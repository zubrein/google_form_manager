import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_form_manager/core/constants.dart';
import 'package:injectable/injectable.dart';

part 'loading_hud_state.dart';

@singleton
class LoadingHudCubit extends Cubit<LoadingHudState> {
  LoadingHudCubit() : super(LoadingHudInitial());

  void showError({String message = defaultErrorMessage}) {
    emit(ShowError(message));
  }

  void show(){
    emit(ShowAnimation());
  }

  void cancel() {
    emit(DismissLoadingHud());
  }
}
