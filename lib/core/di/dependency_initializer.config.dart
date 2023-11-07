// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_form_manager/core/helper/logger.dart' as _i9;
import 'package:google_form_manager/core/loading_hud/loading_hud_cubit.dart'
    as _i8;
import 'package:google_form_manager/feature/auth/data/repositories/user_authentication_repository_impl.dart'
    as _i11;
import 'package:google_form_manager/feature/auth/domain/repositories/user_authentication_repository.dart'
    as _i10;
import 'package:google_form_manager/feature/auth/domain/usecases/logout_use_case.dart'
    as _i15;
import 'package:google_form_manager/feature/auth/domain/usecases/signing_in_use_case.dart'
    as _i16;
import 'package:google_form_manager/feature/auth/ui/cubit/login_cubit.dart'
    as _i17;
import 'package:google_form_manager/feature/form_list/data/repositories/form_list_repository_impl.dart'
    as _i7;
import 'package:google_form_manager/feature/form_list/domain/repositories/form_list_repository.dart'
    as _i6;
import 'package:google_form_manager/feature/form_list/domain/usecases/fetch_form_list_usecase.dart'
    as _i13;
import 'package:google_form_manager/feature/form_list/ui/cubit/form_list_cubit.dart'
    as _i14;
import 'package:google_form_manager/feature/templates/data/create_form_repository_impl.dart'
    as _i4;
import 'package:google_form_manager/feature/templates/domain/repositories/create_form_repository.dart'
    as _i3;
import 'package:google_form_manager/feature/templates/domain/usecases/create_form_usecase.dart'
    as _i5;
import 'package:google_form_manager/feature/templates/ui/cubit/create_form_cubit.dart'
    as _i12;
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
    gh.factory<_i6.FormListRepository>(() => _i7.FormListRepositoryImpl());
    gh.singleton<_i8.LoadingHudCubit>(_i8.LoadingHudCubit());
    gh.singleton<_i9.Log>(_i9.Log());
    gh.factory<_i10.UserAuthenticationRepository>(
        () => _i11.UserAuthRepositoryImpl());
    gh.factory<_i12.CreateFormCubit>(() =>
        _i12.CreateFormCubit(createFormUseCase: gh<_i5.CreateFormUseCase>()));
    gh.factory<_i13.FetchFormListUseCase>(() =>
        _i13.FetchFormListUseCase(repository: gh<_i6.FormListRepository>()));
    gh.factory<_i14.FormListCubit>(
        () => _i14.FormListCubit(gh<_i13.FetchFormListUseCase>()));
    gh.factory<_i15.LogoutUseCase>(() => _i15.LogoutUseCase(
        repository: gh<_i10.UserAuthenticationRepository>()));
    gh.factory<_i16.SigningInUseCase>(() => _i16.SigningInUseCase(
        repository: gh<_i10.UserAuthenticationRepository>()));
    gh.factory<_i17.LoginCubit>(() => _i17.LoginCubit(
          gh<_i16.SigningInUseCase>(),
          gh<_i15.LogoutUseCase>(),
        ));
    return this;
  }
}
