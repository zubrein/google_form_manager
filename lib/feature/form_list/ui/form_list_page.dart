import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/base.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/feature/auth/ui/cubit/login_cubit.dart';
import 'package:google_form_manager/feature/shared/widgets/alert_dialog_widget.dart';
import 'package:google_form_manager/feature/templates/ui/template_page.dart';
import 'package:googleapis/drive/v2.dart';

import '../../../core/loading_hud/loading_hud_cubit.dart';
import '../../google_form/form_tab_page.dart';
import 'cubit/form_list_cubit.dart';

class FormListPage extends StatefulWidget {
  const FormListPage({super.key});

  @override
  State<FormListPage> createState() => _FormListPageState();
}

class _FormListPageState extends State<FormListPage> {
  late FormListCubit _formListCubit;
  late LoadingHudCubit _loadingHudCubit;
  late MenuController menuController;

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
          title: const Text(
            'Form list',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.white,
          leading: Builder(
            builder: (context) {
              return _buildMenuIcon(context);
            },
          ),
          actions: [_buildSubscriptionButton(context)],
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
              listener: _listenFormListCubit,
              builder: (context, state) {
                if (state is FormListFetchSuccessState) {
                  return state.formList.isNotEmpty
                      ? ListView.builder(
                          itemCount: state.formList.length,
                          itemBuilder: (context, position) {
                            return _buildFormListItem(state.formList[position]);
                          })
                      : _buildEmptyListBanner();
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(context),
        drawer: _buildDrawer(),
      ),
    );
  }

  Widget _buildEmptyListBanner() {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(42),
              Image.asset(
                'assets/app_image/form_list_empty_banner.png',
              ),
              const Gap(16),
              const Text(
                'You don\'t have a form yet',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
              const Gap(16),
              const Text(
                'You don\'t have a google form creation at the moment.',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 80.0),
              child: Image.asset(
                'assets/app_image/arrow.png',
                height: 150,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
        width: 220,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          child: ListView(
            children: [_buildLogoutButton()],
          ),
        ));
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TemplatePage()),
            ).then((value) {
              _formListCubit.fetchFormList();
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          splashColor: Colors.transparent,
          child: Image.asset('assets/app_image/add.png'),
        ),
      ),
    );
  }

  void _listenFormListCubit(BuildContext context, Object? state) {
    if (state is FormListFetchInitiatedState) {
      _loadingHudCubit.show();
    } else if (state is FormListFetchSuccessState) {
      _loadingHudCubit.cancel();
    }
  }

  Widget _buildSubscriptionButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: Image.asset(
          'assets/app_image/subscription_logo.png',
          width: 28,
          height: 28,
          fit: BoxFit.fill,
        ));
  }

  Widget _buildMenuIcon(BuildContext context) {
    return IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: Image.asset(
          'assets/app_image/menu_bar_icon.png',
          width: 28,
          height: 28,
          fit: BoxFit.fill,
        ));
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
                builder: (context) => FormTabPage(
                      formId: item.id!,
                    )));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildFormItemThumbnailIcon(item),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(item.title.toString()),
                    Text(item.createdDate.toString()),
                  ],
                ),
              ),
              const Gap(8),
              _buildOptionButton(item),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormItemThumbnailIcon(File item) {
    return SizedBox(
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
    );
  }

  MenuAnchor _buildOptionButton(File item) {
    return MenuAnchor(
        builder:
            (BuildContext context, MenuController controller, Widget? child) {
          menuController = controller;
          return SizedBox(
            height: 40,
            width: 40,
            child: Center(
              child: IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.more_horiz),
                tooltip: 'Show menu',
              ),
            ),
          );
        },
        menuChildren: [
          InkWell(
            onTap: () {
              menuController.close();
              showDialog(
                  context: context,
                  builder: (context) {
                    return confirmationDialog(
                        context: context,
                        message: 'Do you want to delete this form?',
                        onTapContinueButton: () {
                          Navigator.of(context).pop();
                          _formListCubit.deleteForm(item.id!);
                        });
                  });
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Delete'),
            ),
          ),
        ]);
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
