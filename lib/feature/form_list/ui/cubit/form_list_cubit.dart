import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_form_manager/core/helper/google_auth_helper.dart';
import 'package:google_form_manager/feature/auth/ui/cubit/login_cubit.dart';
import 'package:googleapis/drive/v2.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/fetch_form_list_usecase.dart';

part 'form_list_state.dart';

@injectable
class FormListCubit extends Cubit<FormListState> {
  FetchFormListUseCase fetchFormListUseCase;
  LoginCubit loginCubit;

  String token = '';

  FormListCubit(this.fetchFormListUseCase, this.loginCubit) : super(FormListInitial());

  Future<void> fetchFormList() async {
    final httpClient = await googleSigning.authenticatedClient();
    token = httpClient!.credentials.accessToken.data;
    emit(FormListFetchInitiatedState());
    final list = await fetchFormListUseCase();
    emit(FormListFetchSuccessState(list));
  }

  void logout(){
    loginCubit.logout();
  }
}
