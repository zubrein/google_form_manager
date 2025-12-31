import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/base.dart';
import 'package:google_form_manager/core/constants.dart';
import 'package:google_form_manager/core/di/dependency_initializer.dart';
import 'package:google_form_manager/feature/auth/ui/cubit/login_cubit.dart';
import 'package:google_form_manager/feature/premium/ui/upgrade_to_premium_page.dart';
import 'package:google_form_manager/feature/shared/widgets/alert_dialog_widget.dart';
import 'package:google_form_manager/feature/templates/ui/template_page.dart';
import 'package:googleapis/drive/v2.dart';
import 'package:onepref/onepref.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../../../core/loading_hud/loading_hud_cubit.dart';
import '../../google_form/form_tab_page.dart';
import '../../premium/ui/cubit/upgrade_to_premium_cubit.dart';
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

  late UpgradeToPremiumCubit _upgradeToPremiumCubit;

  @override
  void initState() {
    super.initState();
    _loadingHudCubit = sl<LoadingHudCubit>();
    _formListCubit = sl<FormListCubit>();
    _loadingHudCubit.show();
    _formListCubit.fetchFormList();
    _upgradeToPremiumCubit = sl<UpgradeToPremiumCubit>();
    _upgradeToPremiumCubit.iApEngine.inAppPurchase.restorePurchases();
    _upgradeToPremiumCubit.getProducts();
    _upgradeToPremiumCubit.listenPurchase();
  }

  @override
  Widget build(BuildContext context) {
    return Base(
      loadingHudCubit: _loadingHudCubit,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
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
          actions: [
            if (!(OnePref.getRemoveAds() ?? false))
              _buildSubscriptionButton(context)
          ],
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
        width: 280,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                color: const Color(0xff6818B9),
              ),
              const Gap(16),
              if (!(OnePref.getRemoveAds() ?? false))
                _buildDrawerTitle('Subscription'),
              if (!(OnePref.getRemoveAds() ?? false)) const Gap(16),
              if (!(OnePref.getRemoveAds() ?? false))
                _buildDrawerItem(
                  'assets/app_image/upgrade_to_premium.png',
                  'Upgrade to premium',
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const UpgradeToPremiumPage()));
                    // Navigator.pop(context);
                  },
                ),
              if (!(OnePref.getRemoveAds() ?? false)) const Gap(16),
              _buildDrawerTitle('Support Us'),
              const Gap(16),
              _buildDrawerItem(
                'assets/app_image/nav_share.png',
                'Share the app link',
                () async {
                  // Navigator.pop(context);
                  // final result = await Share.shareWithResult(
                  //   'Download the app from ${Platform.isIOS?'App Store':'Google Play Store'} \n${Platform.isIOS ? appStoreShareLink : playStoreShareLink}',
                  // );
                  //
                  // if (result.status == ShareResultStatus.success) {
                  //   return;
                  // }
                },
              ),
              _buildDrawerItem(
                'assets/app_image/rate_us.png',
                'Rate us',
                () {
                  if (Platform.isAndroid) {
                    // launchUrl(Uri.parse(playStoreShareLink));
                  } else if (Platform.isIOS) {
                    // launchUrl(Uri.parse(appStoreRatingLink));
                  }
                },
              ),
              const Gap(16),
              _buildDrawerTitle('Policy'),
              const Gap(16),
              _buildDrawerItem(
                null,
                'Privacy policy',
                () {
                  // launchUrl(Uri.parse(
                  //     'https://codecrew360.xyz/gformsmanager-privacy-policy/'));
                },
              ),
              _buildDrawerItem(
                null,
                'Terms of Use',
                () {
                  // launchUrl(Uri.parse(
                  //     'https://codecrew360.xyz/terms-conditions/'));
                },
              ),
              const Gap(16),
              _buildDrawerTitle('Sign Out'),
              const Gap(16),
              _buildDrawerItem(
                'assets/app_image/logout.png',
                'Sign out',
                () {
                  _formListCubit.logout();
                },
              ),
            ],
          ),
        ));
  }

  Padding _buildDrawerTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xff6818B9),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    String? icon,
    String label,
    Function() onTap,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                icon != null
                    ? Image.asset(
                        icon,
                        height: 24,
                        width: 24,
                      )
                    : const SizedBox(
                        width: 16,
                      ),
                const Gap(8),
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const Expanded(child: SizedBox.shrink()),
                Image.asset(
                  'assets/app_image/right_arrow.png',
                  height: 24,
                  width: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
          highlightElevation: 0,
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
    } else if (state is UnAuthenticateState) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/login', ModalRoute.withName('/'));
    }
  }

  Widget _buildSubscriptionButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UpgradeToPremiumPage()));
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
        elevation: 0.3,
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
                    const Gap(8),
                    Text(item.createdDate.toString(),
                        style: const TextStyle(color: Color(0xff828282))),
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
                icon: const Icon(Icons.more_vert),
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
          fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w700),
    );
  }
}
