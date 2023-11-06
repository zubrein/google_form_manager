import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_form_manager/auth/ui/login_cubit.dart';
import 'package:google_form_manager/base.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/core/loading_hud/loading_hud_cubit.dart';
import 'package:google_form_manager/util/utility.dart';

import '../../core/helper/google_auth_helper.dart';

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

  Widget buildBody() {
    return BlocBuilder<LoginCubit, LoginState>(
      bloc: _loginCubit,
      builder: (context, state) {
        if (state is LoginSuccessState) {
          return Text(
              'name: ${userProfile().displayName} \nid: ${userProfile().id.toString()} \nEmail: ${userProfile().email.toString()}');
        } else {
          return const Text('No user');
        }
      },
    );
  }

  // Future<void> handleOp() async {

  //   var httpClient = await googleSignIn.authenticatedClient();
  //
  //   final form = gf.Form(info: Info(title: 'Hello from App'));
  //
  //   if (httpClient != null) {
  //     await FormsApi(httpClient).forms.create(form).then((value) {
  //       print("DBG: $value");
  //     });
  //   }
  // }
  //
  // Future<void> getList() async {
  //   var httpClient = await googleSignIn.authenticatedClient();
  //
  //   if (httpClient != null) {
  //     final list = await DriveApi(httpClient)
  //         .files
  //         .list(q: "mimeType = 'application/vnd.google-apps.form'");
  //
  //     list.items?.forEach((element) {
  //       print("DBG: ${element.title}  ${element.id}");
  //     });
  //   }
  // }
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
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
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
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  // _loginCubit.logout();
                  _loadingHudCubit.showError();
                },
                child: Container(
                  height: 50,
                  width: 200,
                  color: Colors.blue,
                  child: const Center(
                    child: Text('logout'),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              buildBody()
            ],
          ),
        ),
      ),
    );
  }
}
