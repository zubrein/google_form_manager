// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_form_manager/auth/data/repositories/user_authentication_repository_impl.dart'
    as _i6;
import 'package:google_form_manager/auth/domain/repositories/user_authentication_repository.dart'
    as _i5;
import 'package:google_form_manager/auth/domain/usecases/logout_use_case.dart'
    as _i7;
import 'package:google_form_manager/auth/domain/usecases/signing_in_use_case.dart'
    as _i8;
import 'package:google_form_manager/auth/ui/login_cubit.dart' as _i9;
import 'package:google_form_manager/core/helper/logger.dart' as _i4;
import 'package:google_form_manager/core/loading_hud/loading_hud_cubit.dart'
    as _i3;
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
    gh.singleton<_i3.LoadingHudCubit>(_i3.LoadingHudCubit());
    gh.singleton<_i4.Log>(_i4.Log());
    gh.factory<_i5.UserAuthenticationRepository>(
        () => _i6.UserAuthRepositoryImpl());
    gh.factory<_i7.LogoutUseCase>(() =>
        _i7.LogoutUseCase(repository: gh<_i5.UserAuthenticationRepository>()));
    gh.factory<_i8.SigningInUseCase>(() => _i8.SigningInUseCase(
        repository: gh<_i5.UserAuthenticationRepository>()));
    gh.factory<_i9.LoginCubit>(() => _i9.LoginCubit(
          gh<_i8.SigningInUseCase>(),
          gh<_i7.LogoutUseCase>(),
        ));
    return this;
  }
}
