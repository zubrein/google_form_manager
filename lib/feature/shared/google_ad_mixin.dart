import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/helper/logger.dart';

mixin GoogleAdMixin {
  RewardedInterstitialAd? _rewardedInterstitialAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5354046379'
      : 'ca-app-pub-3940256099942544/6978759866';

  void showAdCallback(Function() operation) {
    _rewardedInterstitialAd?.show(
        onUserEarnedReward: (AdWithoutView view, RewardItem rewardItem) {
      operation.call();
      loadAd();
    });
  }

  void loadAd() {
    RewardedInterstitialAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback:
            RewardedInterstitialAdLoadCallback(onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {
            Log.info('Add showed');
          },
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {
            Log.info('Impression added');
          },
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
            Log.info('error $err');
          },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
            Log.info('Ad dismissed');
          },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {
            Log.info('Ad clicked');
          });

          // Keep a reference to the ad so you can show it later.
          _rewardedInterstitialAd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          // ignore: avoid_print
          print('RewardedInterstitialAd failed to load: $error');
        }));
  }
}
