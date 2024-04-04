import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import '../../../base.dart';
import '../../../core/di/dependency_initializer.dart';
import '../../../core/loading_hud/loading_hud_cubit.dart';
import 'cubit/upgrade_to_premium_cubit.dart';

class UpgradeToPremiumPage extends StatefulWidget {
  const UpgradeToPremiumPage({super.key});

  @override
  State<UpgradeToPremiumPage> createState() => _UpgradeToPremiumPageState();
}

class _UpgradeToPremiumPageState extends State<UpgradeToPremiumPage> {
  late LoadingHudCubit _loadingHudCubit;
  late UpgradeToPremiumCubit _upgradeToPremiumCubit;
  ButtonType selectedButtonType = ButtonType.yearly;

  @override
  void initState() {
    super.initState();
    _loadingHudCubit = sl<LoadingHudCubit>();
    _upgradeToPremiumCubit = sl<UpgradeToPremiumCubit>();
    _upgradeToPremiumCubit.getProducts();
    _upgradeToPremiumCubit.listenPurchase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Base(
        loadingHudCubit: _loadingHudCubit,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            titleSpacing: 0.0,
            title: const Text(
              'Become Premium',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            backgroundColor: Colors.white,
            leading: Builder(
              builder: (context) {
                return _buildBackIcon(context);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/app_image/premium_banner.png',
                  ),
                  const Gap(16),
                  _buildPromotionBanner(),
                  const Gap(16),
                  _buildTags(),
                  const Gap(16),
                  _buildPurchaseButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildPromotionBanner() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildPromoteLabels(
                'assets/app_image/response_refresh.png',
                'Unlimited responses refresh',
              ),
              const Gap(8),
              _buildPromoteLabels(
                'assets/app_image/export_to_csv.png',
                'Export Responses to Google Sheets',
              ),
              const Gap(8),
              _buildPromoteLabels(
                'assets/app_image/remove_ads.png',
                'Remove Ads',
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell _buildPurchaseButton() {
    return InkWell(
      onTap: () {
        doSubscribe();
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xff6818B9),
        ),
        child: const Center(
          child: Text(
            'Purchase',
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Row _buildPromoteLabels(String assetPath, String label) {
    return Row(
      children: [
        Image.asset(
          assetPath,
          height: 28,
          width: 28,
        ),
        const Gap(8),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildBackIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: IconButton(
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          )),
    );
  }

  Widget _buildTags() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildWeeklySubscribeButton(),
        _buildYearlySubscribeButton(),
        _buildMonthlySubscribeButton(),
      ],
    );
  }

  InkWell _buildMonthlySubscribeButton() {
    return InkWell(
        onTap: () {
          setState(() {
            selectedButtonType = ButtonType.monthly;
          });
        },
        child: Container(
            decoration: selectedButtonType == ButtonType.monthly
                ? selectedDecor()
                : unSelectedDecor(),
            child: _buildTagTexts('MONTHLY', '4.99', 'per month')));
  }

  InkWell _buildYearlySubscribeButton() {
    return InkWell(
      onTap: () {
        setState(() {
          selectedButtonType = ButtonType.yearly;
        });
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
                decoration: selectedButtonType == ButtonType.yearly
                    ? selectedDecor()
                    : unSelectedDecor(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: _buildTagTexts('ANNUAL', '29.99', 'per year'),
                )),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xff6818B9),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Text(
                'Save 85%',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InkWell _buildWeeklySubscribeButton() {
    return InkWell(
        onTap: () {
          setState(() {
            selectedButtonType = ButtonType.weekly;
          });
        },
        child: Container(
            decoration: selectedButtonType == ButtonType.weekly
                ? selectedDecor()
                : unSelectedDecor(),
            child: _buildTagTexts('WEEKLY', '1.99', 'per week')));
  }

  void doSubscribe() async {
    if (Platform.isIOS) {
      final transactions = await SKPaymentQueueWrapper().transactions();
      for (var transaction in transactions) {
        await SKPaymentQueueWrapper().finishTransaction(transaction);
      }
    }

    if (selectedButtonType == ButtonType.weekly) {
      if (_upgradeToPremiumCubit.weeklyProducts.isNotEmpty) {
        _upgradeToPremiumCubit.iApEngine.handlePurchase(
          _upgradeToPremiumCubit.weeklyProducts.first,
          _upgradeToPremiumCubit.weeklyProductIds,
        );
      }
    } else if (selectedButtonType == ButtonType.yearly) {
      if (_upgradeToPremiumCubit.yearlyProducts.isNotEmpty) {
        _upgradeToPremiumCubit.iApEngine.handlePurchase(
          _upgradeToPremiumCubit.yearlyProducts.first,
          _upgradeToPremiumCubit.yearlyProductIds,
        );
      }
    } else if (selectedButtonType == ButtonType.monthly) {
      if (_upgradeToPremiumCubit.monthlyProducts.isNotEmpty) {
        _upgradeToPremiumCubit.iApEngine.handlePurchase(
          _upgradeToPremiumCubit.monthlyProducts.first,
          _upgradeToPremiumCubit.monthlyProductIds,
        );
      }
    }
  }

  Widget _buildTagTexts(String title, String amount, String footer) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xff6818B9)),
          ),
          const Gap(16),
          Text(
            '\$ $amount',
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xff6818B9)),
          ),
          const Gap(16),
          Text(
            footer,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
          )
        ],
      ),
    );
  }

  BoxDecoration selectedDecor() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xff6818B9)),
      color: const Color(0xff6818B9).withOpacity(.01),
      boxShadow: [
        BoxShadow(
          color: const Color(0xff6818B9).withOpacity(0.15),
          spreadRadius: 1,
          blurRadius: 1,
          offset: const Offset(0, 0), // changes position of shadow
        ),
      ],
    );
  }

  BoxDecoration unSelectedDecor() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.black12),
    );
  }
}

enum ButtonType { weekly, monthly, yearly }
