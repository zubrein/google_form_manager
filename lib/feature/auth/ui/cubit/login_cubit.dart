import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_form_manager/core/helper/google_auth_helper.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/signing_in_use_case.dart';

part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final SigningInUseCase signingIn;
  final LogoutUseCase logoutUseCase;

  LoginCubit(this.signingIn, this.logoutUseCase) : super(LoginInitial());

  Future<void> signIn() async {
    await signingIn();
  }

  Future<void> logout() async {
    await logoutUseCase();
  }

  void userExists() {
    emit(LoginSuccessState());
  }

  void listenUserLoginState() {
    googleSigning.onCurrentUserChanged.listen((account) {
      if (account != null) {
        emit(LoginSuccessState());
      }
    });
  }
}
