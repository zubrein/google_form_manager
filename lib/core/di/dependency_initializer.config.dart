// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_form_manager/auth/data/repositories/user_authentication_repository_impl.dart'
    as _i8;
import 'package:google_form_manager/auth/domain/repositories/user_authentication_repository.dart'
    as _i7;
import 'package:google_form_manager/auth/domain/usecases/logout_use_case.dart'
    as _i11;
import 'package:google_form_manager/auth/domain/usecases/signing_in_use_case.dart'
    as _i12;
import 'package:google_form_manager/auth/ui/cubit/login_cubit.dart' as _i13;
import 'package:google_form_manager/core/helper/logger.dart' as _i6;
import 'package:google_form_manager/core/loading_hud/loading_hud_cubit.dart'
    as _i5;
import 'package:google_form_manager/form_list/data/repositories/form_list_repository_impl.dart'
    as _i4;
import 'package:google_form_manager/form_list/domain/repositories/form_list_repository.dart'
    as _i3;
import 'package:google_form_manager/form_list/domain/usecases/fetch_form_list_usecase.dart'
    as _i9;
import 'package:google_form_manager/form_list/ui/cubit/form_list_cubit.dart'
    as _i10;
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
    gh.factory<_i3.FormListRepository>(() => _i4.FormListRepositoryImpl());
    gh.singleton<_i5.LoadingHudCubit>(_i5.LoadingHudCubit());
    gh.singleton<_i6.Log>(_i6.Log());
    gh.factory<_i7.UserAuthenticationRepository>(
        () => _i8.UserAuthRepositoryImpl());
    gh.factory<_i9.FetchFormListUseCase>(() =>
        _i9.FetchFormListUseCase(repository: gh<_i3.FormListRepository>()));
    gh.factory<_i10.FormListCubit>(
        () => _i10.FormListCubit(gh<_i9.FetchFormListUseCase>()));
    gh.factory<_i11.LogoutUseCase>(() =>
        _i11.LogoutUseCase(repository: gh<_i7.UserAuthenticationRepository>()));
    gh.factory<_i12.SigningInUseCase>(() => _i12.SigningInUseCase(
        repository: gh<_i7.UserAuthenticationRepository>()));
    gh.factory<_i13.LoginCubit>(() => _i13.LoginCubit(
          gh<_i12.SigningInUseCase>(),
          gh<_i11.LogoutUseCase>(),
        ));
    return this;
  }
}
