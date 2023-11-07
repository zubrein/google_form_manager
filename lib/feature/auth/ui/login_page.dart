import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_form_manager/base.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/core/helper/google_auth_helper.dart';
import 'package:google_form_manager/core/loading_hud/loading_hud_cubit.dart';

import '../../form_list/ui/form_list_page.dart';
import 'cubit/login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginCubit _loginCubit;
  late LoadingHudCubit _loadingHudCubit;

  @override
  void initState() {
    super.initState();
    GoogleAuthHelper().init();
    _loginCubit = sl<LoginCubit>();
    _loadingHudCubit = sl<LoadingHudCubit>();
    _loginCubit.listenUserLoginState();
  }

  //
  // Future<void> batchUpdate() async {
  //   var httpClient = await googleSignIn.authenticatedClient();
  //
  //   if (httpClient != null) {
  //     await FormsApi(httpClient)
  //         .forms
  //         .batchUpdate(
  //           BatchUpdateFormRequest(
  //             includeFormInResponse: true,
  //             requests: [
  //               Request(
  //                 createItem: gf.CreateItemRequest(
  //                   item: gf.Item(
  //                       questionItem: gf.QuestionItem(
  //                           question: gf.Question(
  //                               choiceQuestion: gf.ChoiceQuestion(options: [
  //                     Option(value: 'opta'),
  //                     Option(value: 'optb'),
  //                     Option(value: 'optc'),
  //                     Option(value: 'optd'),
  //                   ], type: 'RADIO')))),
  //                   location: gf.Location(
  //                     index: 0,
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //           '10KTgx0j7emz5frPgDZl3_aTuhGiP3lW2jFpB9aOa3DM',
  //           $fields: '*',
  //         )
  //         .then((value) {
  //       print('DBG: $value');
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Base(
      loadingHudCubit: _loadingHudCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: BlocListener<LoginCubit, LoginState>(
          bloc: _loginCubit,
          listener: (context, state) {
            if (state is LoginSuccessState) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const FormListPage()),
                  ModalRoute.withName('/'));
            }
          },
          child: Center(
            child: GestureDetector(
              onTap: () {
                _loginCubit.signingIn();
              },
              child: Container(
                height: 50,
                width: 200,
                color: Colors.blue,
                child: const Center(
                  child: Text('login'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


}
