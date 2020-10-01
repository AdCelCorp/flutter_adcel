abstract class AdCelBannerListener {
  void onBannerLoad();
  void onBannerAllProvidersFailedToLoad();
  void onBannerFailedToLoadProvider(String provider);
  void onBannerFailedToLoad();
  void onBannerClicked();
}