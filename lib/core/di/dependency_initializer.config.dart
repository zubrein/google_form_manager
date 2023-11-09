// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_form_manager/core/helper/logger.dart' as _i12;
import 'package:google_form_manager/core/loading_hud/loading_hud_cubit.dart'
    as _i11;
import 'package:google_form_manager/feature/auth/data/repositories/user_authentication_repository_impl.dart'
    as _i14;
import 'package:google_form_manager/feature/auth/domain/repositories/user_authentication_repository.dart'
    as _i13;
import 'package:google_form_manager/feature/auth/domain/usecases/logout_use_case.dart'
    as _i20;
import 'package:google_form_manager/feature/auth/domain/usecases/signing_in_use_case.dart'
    as _i21;
import 'package:google_form_manager/feature/auth/ui/cubit/login_cubit.dart'
    as _i23;
import 'package:google_form_manager/feature/edit_form/data/repositories/edit_form_repository_impl.dart'
    as _i7;
import 'package:google_form_manager/feature/edit_form/domain/repository/edit_form_repository.dart'
    as _i6;
import 'package:google_form_manager/feature/edit_form/domain/usecases/batch_update_usecase.dart'
    as _i15;
import 'package:google_form_manager/feature/edit_form/domain/usecases/fetch_form_usecase.dart'
    as _i8;
import 'package:google_form_manager/feature/edit_form/ui/cubit/batch_update_cubit.dart'
    as _i22;
import 'package:google_form_manager/feature/edit_form/ui/cubit/edit_form_cubit.dart'
    as _i17;
import 'package:google_form_manager/feature/form_list/data/repositories/form_list_repository_impl.dart'
    as _i10;
import 'package:google_form_manager/feature/form_list/domain/repositories/form_list_repository.dart'
    as _i9;
import 'package:google_form_manager/feature/form_list/domain/usecases/fetch_form_list_usecase.dart'
    as _i18;
import 'package:google_form_manager/feature/form_list/ui/cubit/form_list_cubit.dart'
    as _i19;
import 'package:google_form_manager/feature/templates/data/create_form_repository_impl.dart'
    as _i4;
import 'package:google_form_manager/feature/templates/domain/repositories/create_form_repository.dart'
    as _i3;
import 'package:google_form_manager/feature/templates/domain/usecases/create_form_usecase.dart'
    as _i5;
import 'package:google_form_manager/feature/templates/ui/cubit/create_form_cubit.dart'
    as _i16;
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
    gh.factory<_i3.CreateFormRepository>(() => _i4.CreateFormRepositoryImpl());
    gh.factory<_i5.CreateFormUseCase>(
        () => _i5.CreateFormUseCase(gh<_i3.CreateFormRepository>()));
    gh.factory<_i6.EditFormRepository>(() => _i7.EditFormRepositoryImpl());
    gh.factory<_i8.FetchFormUseCase>(
        () => _i8.FetchFormUseCase(gh<_i6.EditFormRepository>()));
    gh.factory<_i9.FormListRepository>(() => _i10.FormListRepositoryImpl());
    gh.singleton<_i11.LoadingHudCubit>(_i11.LoadingHudCubit());
    gh.singleton<_i12.Log>(_i12.Log());
    gh.factory<_i13.UserAuthenticationRepository>(
        () => _i14.UserAuthRepositoryImpl());
    gh.factory<_i15.BatchUpdateUseCase>(
        () => _i15.BatchUpdateUseCase(gh<_i6.EditFormRepository>()));
    gh.factory<_i16.CreateFormCubit>(() =>
        _i16.CreateFormCubit(createFormUseCase: gh<_i5.CreateFormUseCase>()));
    gh.factory<_i17.EditFormCubit>(
        () => _i17.EditFormCubit(gh<_i8.FetchFormUseCase>()));
    gh.factory<_i18.FetchFormListUseCase>(() =>
        _i18.FetchFormListUseCase(repository: gh<_i9.FormListRepository>()));
    gh.factory<_i19.FormListCubit>(
        () => _i19.FormListCubit(gh<_i18.FetchFormListUseCase>()));
    gh.factory<_i20.LogoutUseCase>(() => _i20.LogoutUseCase(
        repository: gh<_i13.UserAuthenticationRepository>()));
    gh.factory<_i21.SigningInUseCase>(() => _i21.SigningInUseCase(
        repository: gh<_i13.UserAuthenticationRepository>()));
    gh.singleton<_i22.BatchUpdateCubit>(
        _i22.BatchUpdateCubit(gh<_i15.BatchUpdateUseCase>()));
    gh.factory<_i23.LoginCubit>(() => _i23.LoginCubit(
          gh<_i21.SigningInUseCase>(),
          gh<_i20.LogoutUseCase>(),
        ));
    return this;
  }
}
