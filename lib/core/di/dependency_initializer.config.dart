// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_form_manager/core/helper/logger.dart' as _i13;
import 'package:google_form_manager/core/loading_hud/loading_hud_cubit.dart'
    as _i12;
import 'package:google_form_manager/feature/auth/data/repositories/user_authentication_repository_impl.dart'
    as _i15;
import 'package:google_form_manager/feature/auth/domain/repositories/user_authentication_repository.dart'
    as _i14;
import 'package:google_form_manager/feature/auth/domain/usecases/logout_use_case.dart'
    as _i21;
import 'package:google_form_manager/feature/auth/domain/usecases/signing_in_use_case.dart'
    as _i22;
import 'package:google_form_manager/feature/auth/ui/cubit/login_cubit.dart'
    as _i24;
import 'package:google_form_manager/feature/edit_form/data/repositories/edit_form_repository_impl.dart'
    as _i8;
import 'package:google_form_manager/feature/edit_form/domain/repository/edit_form_repository.dart'
    as _i7;
import 'package:google_form_manager/feature/edit_form/domain/usecases/batch_update_usecase.dart'
    as _i16;
import 'package:google_form_manager/feature/edit_form/domain/usecases/check_question_type_usecase.dart'
    as _i3;
import 'package:google_form_manager/feature/edit_form/domain/usecases/fetch_form_usecase.dart'
    as _i9;
import 'package:google_form_manager/feature/edit_form/ui/cubit/batch_update_cubit.dart'
    as _i23;
import 'package:google_form_manager/feature/edit_form/ui/cubit/edit_form_cubit.dart'
    as _i18;
import 'package:google_form_manager/feature/form_list/data/repositories/form_list_repository_impl.dart'
    as _i11;
import 'package:google_form_manager/feature/form_list/domain/repositories/form_list_repository.dart'
    as _i10;
import 'package:google_form_manager/feature/form_list/domain/usecases/fetch_form_list_usecase.dart'
    as _i19;
import 'package:google_form_manager/feature/form_list/ui/cubit/form_list_cubit.dart'
    as _i20;
import 'package:google_form_manager/feature/templates/data/create_form_repository_impl.dart'
    as _i5;
import 'package:google_form_manager/feature/templates/domain/repositories/create_form_repository.dart'
    as _i4;
import 'package:google_form_manager/feature/templates/domain/usecases/create_form_usecase.dart'
    as _i6;
import 'package:google_form_manager/feature/templates/ui/cubit/create_form_cubit.dart'
    as _i17;
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
    gh.factory<_i9.FetchFormUseCase>(
        () => _i9.FetchFormUseCase(gh<_i7.EditFormRepository>()));
    gh.factory<_i10.FormListRepository>(() => _i11.FormListRepositoryImpl());
    gh.singleton<_i12.LoadingHudCubit>(_i12.LoadingHudCubit());
    gh.singleton<_i13.Log>(_i13.Log());
    gh.factory<_i14.UserAuthenticationRepository>(
        () => _i15.UserAuthRepositoryImpl());
    gh.factory<_i16.BatchUpdateUseCase>(
        () => _i16.BatchUpdateUseCase(gh<_i7.EditFormRepository>()));
    gh.factory<_i17.CreateFormCubit>(() =>
        _i17.CreateFormCubit(createFormUseCase: gh<_i6.CreateFormUseCase>()));
    gh.factory<_i18.EditFormCubit>(() => _i18.EditFormCubit(
          gh<_i9.FetchFormUseCase>(),
          gh<_i3.CheckQuestionTypeUseCase>(),
        ));
    gh.factory<_i19.FetchFormListUseCase>(() =>
        _i19.FetchFormListUseCase(repository: gh<_i10.FormListRepository>()));
    gh.factory<_i20.FormListCubit>(
        () => _i20.FormListCubit(gh<_i19.FetchFormListUseCase>()));
    gh.factory<_i21.LogoutUseCase>(() => _i21.LogoutUseCase(
        repository: gh<_i14.UserAuthenticationRepository>()));
    gh.factory<_i22.SigningInUseCase>(() => _i22.SigningInUseCase(
        repository: gh<_i14.UserAuthenticationRepository>()));
    gh.singleton<_i23.BatchUpdateCubit>(
        _i23.BatchUpdateCubit(gh<_i16.BatchUpdateUseCase>()));
    gh.factory<_i24.LoginCubit>(() => _i24.LoginCubit(
          gh<_i22.SigningInUseCase>(),
          gh<_i21.LogoutUseCase>(),
        ));
    return this;
  }
}
