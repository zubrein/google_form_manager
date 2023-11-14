import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/base.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/feature/auth/ui/cubit/login_cubit.dart';
import 'package:google_form_manager/feature/edit_form/ui/edit_form_page.dart';
import 'package:google_form_manager/feature/templates/ui/template_page.dart';
import 'package:googleapis/drive/v2.dart';

import '../../../core/loading_hud/loading_hud_cubit.dart';
import 'cubit/form_list_cubit.dart';

class FormListPage extends StatefulWidget {
  const FormListPage({super.key});

  @override
  State<FormListPage> createState() => _FormListPageState();
}

class _FormListPageState extends State<FormListPage> {
  late FormListCubit _formListCubit;
  late LoadingHudCubit _loadingHudCubit;

  @override
  void initState() {
    super.initState();
    _loadingHudCubit = sl<LoadingHudCubit>();
    _formListCubit = sl<FormListCubit>();
    _loadingHudCubit.show();
    _formListCubit.fetchFormList();
  }

  @override
  Widget build(BuildContext context) {
    return Base(
      loadingHudCubit: _loadingHudCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Form list'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocListener<LoginCubit, LoginState>(
            bloc: _formListCubit.loginCubit,
            listener: (context, state) {
              if (state is LogoutState) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', ModalRoute.withName('/'));
              }
            },
            child: BlocConsumer(
              bloc: _formListCubit,
              listener: (BuildContext context, Object? state) {
                if (state is FormListFetchSuccessState) {
                  _loadingHudCubit.cancel();
                }
              },
              builder: (context, state) {
                if (state is FormListFetchSuccessState) {
                  return ListView.builder(
                      itemCount: state.formList.length,
                      itemBuilder: (context, position) {
                        return _buildFormListItem(state.formList[position]);
                      });
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TemplatePage()),
            ).then((value) {
              _formListCubit.fetchFormList();
            });
          },
          child: const Icon(Icons.add),
        ),
        drawer: Drawer(
            width: 220,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
              child: ListView(
                children: [_buildLogoutButton()],
              ),
            )),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        _formListCubit.logout();
      },
      child: const Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.logout,
                size: 18,
              ),
              Gap(6),
              Text('Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  )),
            ],
          ),
          Gap(8),
          Divider(
            height: 1,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }

  Widget _buildFormListItem(File item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditFormPage(formId: item.id!)));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                height: 70,
                width: 50,
                child: Image.network(
                  item.thumbnailLink!,
                  headers: <String, String>{
                    'Authorization': 'Bearer ${_formListCubit.token}',
                    'Custom-Header': 'Custom-Value',
                  },
                  fit: BoxFit.fill,
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(item.title.toString()),
                    Text(item.createdDate.toString()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _formListCubit.close();
    super.dispose();
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
          fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w700),
    );
  }
}
