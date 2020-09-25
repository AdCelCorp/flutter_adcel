abstract class AdCelInterstitialListener {
  void onFirstInterstitialLoad(String adType, String provider);
  void onInterstitialStarted(String adType, String provider);
  void onInterstitialClicked(String adType, String provider);
  void onInterstitialClosed(String adType, String provider);
  void onInterstitialFailLoad(String adType, String error);
  void onInterstitialFailedToShow(String adType);
  void onRewardedCompleted(String adProvider, String currencyName, String currencyValue);
}