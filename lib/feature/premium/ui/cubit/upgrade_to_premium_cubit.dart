import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_form_manager/core/helper/logger.dart';
import 'package:google_form_manager/util/utility.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:injectable/injectable.dart';
import 'package:onepref/onepref.dart';

part 'upgrade_to_premium_state.dart';

@singleton
class UpgradeToPremiumCubit extends Cubit<UpgradeToPremiumState> {
  UpgradeToPremiumCubit() : super(UpgradeToPremiumInitial());

  late final List<ProductDetails> weeklyProducts = <ProductDetails>[];
  late final List<ProductDetails> monthlyProducts = <ProductDetails>[];
  late final List<ProductDetails> yearlyProducts = <ProductDetails>[];
  final List<ProductId> weeklyProductIds = getWeeklyProductIds();
  final List<ProductId> monthlyProductIds = getMonthlyProductIds();
  final List<ProductId> yearlyProductIds = getYearlyProductIds();
  bool isSubscribed = false;
  IApEngine iApEngine = IApEngine();

  Future<void> getProducts() async {
    await iApEngine.getIsAvailable().then((exists) async {
      if (exists) {
        await iApEngine.queryProducts(weeklyProductIds).then((response) {
          weeklyProducts.addAll(response.productDetails);
        });

        await iApEngine.queryProducts(monthlyProductIds).then((response) {
          monthlyProducts.addAll(response.productDetails);
        });

        await iApEngine.queryProducts(yearlyProductIds).then((response) {
          yearlyProducts.addAll(response.productDetails);
        });
      }
    });
  }

  void listenPurchase() {
    iApEngine.inAppPurchase.purchaseStream.listen(
        (List<PurchaseDetails> purchaseDetailsList) {
      listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {}, onError: (Object error) {});
  }

  void listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    if (purchaseDetailsList.isNotEmpty) {
      for (var purchaseDetails in purchaseDetailsList) {
        if (purchaseDetails.status == PurchaseStatus.restored ||
            purchaseDetails.status == PurchaseStatus.purchased) {
          Map purchaseData = json.decode(
            purchaseDetails.verificationData.localVerificationData,
          );

          Log.info(purchaseData.toString());

          if (purchaseData['acknowledged']) {
            Log.info('restore purchase');
            OnePref.setRemoveAds(true);
          } else {
            Log.info('first time purchase');
            if (Platform.isAndroid) {
              final InAppPurchaseAndroidPlatformAddition
                  androidPlatformAddition = iApEngine.inAppPurchase
                      .getPlatformAddition<
                          InAppPurchaseAndroidPlatformAddition>();
              await androidPlatformAddition
                  .consumePurchase(purchaseDetails)
                  .then((value) {
                Log.info('Subscribed');
                OnePref.setRemoveAds(true);
              });
            }

            if (purchaseDetails.pendingCompletePurchase) {
              await iApEngine.inAppPurchase
                  .completePurchase(purchaseDetails)
                  .then((value) {
                Log.info('Payment Completed');
                OnePref.setRemoveAds(true);
              });
            }
          }
        }
      }
    } else {
      OnePref.setRemoveAds(false);
    }
  }
}
