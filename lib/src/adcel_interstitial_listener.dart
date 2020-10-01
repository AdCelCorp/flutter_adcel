abstract class AdCelInterstitialListener {
  void onFirstInterstitialLoad(String adType, String provider);
  void onInterstitialWillAppear(String adType, String provider);
  void onInterstitialClicked(String adType, String provider);
  void onInterstitialDidDisappear(String adType, String provider);
  void onInterstitialFailLoad(String adType, String error);
  void onInterstitialFailedToShow(String adType);
  void onRewardedCompleted(String adProvider, String currencyName, String currencyValue);
}
