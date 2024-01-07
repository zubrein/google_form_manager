// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_form_manager/core/helper/logger.dart' as _i14;
import 'package:google_form_manager/core/loading_hud/loading_hud_cubit.dart'
    as _i13;
import 'package:google_form_manager/feature/auth/data/repositories/user_authentication_repository_impl.dart'
    as _i16;
import 'package:google_form_manager/feature/auth/domain/repositories/user_authentication_repository.dart'
    as _i15;
import 'package:google_form_manager/feature/auth/domain/usecases/logout_use_case.dart'
    as _i22;
import 'package:google_form_manager/feature/auth/domain/usecases/signing_in_use_case.dart'
    as _i23;
import 'package:google_form_manager/feature/auth/ui/cubit/login_cubit.dart'
    as _i24;
import 'package:google_form_manager/feature/form_list/data/repositories/form_list_repository_impl.dart'
    as _i12;
import 'package:google_form_manager/feature/form_list/domain/repositories/form_list_repository.dart'
    as _i11;
import 'package:google_form_manager/feature/form_list/domain/usecases/delete_form_list_usecase.dart'
    as _i19;
import 'package:google_form_manager/feature/form_list/domain/usecases/fetch_form_list_usecase.dart'
    as _i20;
import 'package:google_form_manager/feature/form_list/ui/cubit/form_list_cubit.dart'
    as _i25;
import 'package:google_form_manager/feature/google_form/edit_form/data/repositories/edit_form_repository_impl.dart'
    as _i8;
import 'package:google_form_manager/feature/google_form/edit_form/domain/repository/edit_form_repository.dart'
    as _i7;
import 'package:google_form_manager/feature/google_form/edit_form/domain/usecases/batch_update_usecase.dart'
    as _i17;
import 'package:google_form_manager/feature/google_form/edit_form/domain/usecases/check_question_type_usecase.dart'
    as _i3;
import 'package:google_form_manager/feature/google_form/edit_form/domain/usecases/fetch_form_responses_usecase.dart'
    as _i9;
import 'package:google_form_manager/feature/google_form/edit_form/domain/usecases/fetch_form_usecase.dart'
    as _i10;
import 'package:google_form_manager/feature/google_form/edit_form/ui/cubit/form_cubit.dart'
    as _i21;
import 'package:google_form_manager/feature/templates/data/create_form_repository_impl.dart'
    as _i5;
import 'package:google_form_manager/feature/templates/domain/repositories/create_form_repository.dart'
    as _i4;
import 'package:google_form_manager/feature/templates/domain/usecases/create_form_usecase.dart'
    as _i6;
import 'package:google_form_manager/feature/templates/ui/cubit/create_form_cubit.dart'
    as _i18;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.CheckQuestionTypeUseCase>(
        () => _i3.CheckQuestionTypeUseCase());
    gh.factory<_i4.CreateFormRepository>(() => _i5.CreateFormRepositoryImpl());
    gh.factory<_i6.CreateFormUseCase>(
        () => _i6.CreateFormUseCase(gh<_i4.CreateFormRepository>()));
    gh.factory<_i7.EditFormRepository>(() => _i8.EditFormRepositoryImpl());
    gh.factory<_i9.FetchFormResponsesUseCase>(
        () => _i9.FetchFormResponsesUseCase(gh<_i7.EditFormRepository>()));
    gh.factory<_i10.FetchFormUseCase>(
        () => _i10.FetchFormUseCase(gh<_i7.EditFormRepository>()));
    gh.factory<_i11.FormListRepository>(() => _i12.FormListRepositoryImpl());
    gh.singleton<_i13.LoadingHudCubit>(_i13.LoadingHudCubit());
    gh.singleton<_i14.Log>(_i14.Log());
    gh.factory<_i15.UserAuthenticationRepository>(
        () => _i16.UserAuthRepositoryImpl());
    gh.factory<_i17.BatchUpdateUseCase>(
        () => _i17.BatchUpdateUseCase(gh<_i7.EditFormRepository>()));
    gh.factory<_i18.CreateFormCubit>(() => _i18.CreateFormCubit(
          createFormUseCase: gh<_i6.CreateFormUseCase>(),
          batchUpdateUseCase: gh<_i17.BatchUpdateUseCase>(),
        ));
    gh.factory<_i19.DeleteFormListUseCase>(() =>
        _i19.DeleteFormListUseCase(repository: gh<_i11.FormListRepository>()));
    gh.factory<_i20.FetchFormListUseCase>(() =>
        _i20.FetchFormListUseCase(repository: gh<_i11.FormListRepository>()));
    gh.factory<_i21.FormCubit>(() => _i21.FormCubit(
          gh<_i10.FetchFormUseCase>(),
          gh<_i3.CheckQuestionTypeUseCase>(),
          gh<_i9.FetchFormResponsesUseCase>(),
          gh<_i17.BatchUpdateUseCase>(),
        ));
    gh.factory<_i22.LogoutUseCase>(() => _i22.LogoutUseCase(
        repository: gh<_i15.UserAuthenticationRepository>()));
    gh.factory<_i23.SigningInUseCase>(() => _i23.SigningInUseCase(
        repository: gh<_i15.UserAuthenticationRepository>()));
    gh.factory<_i24.LoginCubit>(() => _i24.LoginCubit(
          gh<_i23.SigningInUseCase>(),
          gh<_i22.LogoutUseCase>(),
        ));
    gh.factory<_i25.FormListCubit>(() => _i25.FormListCubit(
          gh<_i20.FetchFormListUseCase>(),
          gh<_i19.DeleteFormListUseCase>(),
          gh<_i24.LoginCubit>(),
        ));
    return this;
  }
}
