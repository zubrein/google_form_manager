import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_form_manager/base.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/core/helper/google_auth_helper.dart';
import 'package:google_form_manager/core/loading_hud/loading_hud_cubit.dart';
import 'package:google_form_manager/util/utility.dart';

import '../../premium/ui/cubit/upgrade_to_premium_cubit.dart';
import 'cubit/login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginCubit _loginCubit;
  late LoadingHudCubit _loadingHudCubit;
  late UpgradeToPremiumCubit _upgradeToPremiumCubit;

  @override
  void initState() {
    super.initState();
    GoogleAuthHelper().init();
    _loginCubit = sl<LoginCubit>();
    _loadingHudCubit = sl<LoadingHudCubit>();
    _upgradeToPremiumCubit = sl<UpgradeToPremiumCubit>();
    _loginCubit.listenUserLoginState();
    _upgradeToPremiumCubit.iApEngine.inAppPurchase.restorePurchases();
    _upgradeToPremiumCubit.getProducts();
    _upgradeToPremiumCubit.listenPurchase();
  }

  @override
  Widget build(BuildContext context) {
    return Base(
      loadingHudCubit: _loadingHudCubit,
      child: Scaffold(
        body: BlocListener<LoginCubit, LoginState>(
          bloc: _loginCubit,
          listener: (context, state) {
            if (state is LoginSuccessState) {
              Navigator.pushNamedAndRemoveUntil(context, '/formList',
                  (Route route) => route.settings.name == 'login');
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Image.asset(
                  'assets/app_image/login_page_banner.png',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: GestureDetector(
                  onTap: () async {
                    if (await checkInternet()) {
                      _loginCubit.signingIn();
                    } else {
                      _loadingHudCubit.showError(
                        message: 'No internet connection',
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Image.asset(
                      'assets/app_image/signin_logo.png',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
