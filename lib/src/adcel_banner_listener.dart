abstract class AdCelBannerListener {
  void onBannerLoad();
  void onBannerFailedToLoadProvider(String provider);
  void onBannerFailedToLoad();
  void onBannerClicked();
}