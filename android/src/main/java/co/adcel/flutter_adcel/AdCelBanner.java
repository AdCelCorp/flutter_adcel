package co.adcel.flutter_adcel;

import android.app.Activity;
import android.content.Context;
import android.view.View;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;

import co.adcel.adbanner.AdSize;
import co.adcel.adbanner.BannerAdContainer;
import co.adcel.adbanner.BannerListener;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class AdCelBanner implements MethodChannel.MethodCallHandler, PlatformView, BannerListener {
    private static final String AD_SIZE_300x50 = "300x50";
    private static final String AD_SIZE_320x50 = "320x50";
    private static final String AD_SIZE_300x250 = "300x250";
    private static final String AD_SIZE_728x90 = "728x90";

    private final MethodChannel channel;
    private final BannerAdContainer adView;

    public AdCelBanner(Activity activity, BinaryMessenger messenger, int id, Object args) {
        this.channel = new MethodChannel(messenger, "flutter_adcel/banner_" + id);
        this.adView = new BannerAdContainer(activity);

        this.channel.setMethodCallHandler(this);
        this.adView.setSize(getSize((String)((Map)args).get("adSize")));
    }

    private AdSize getSize(String size) {
        switch (size) {
            case AD_SIZE_300x50:
                return AdSize.BANNER_300x50;
            case AD_SIZE_300x250:
                return AdSize.BANNER_300x250;
            case AD_SIZE_728x90:
                return AdSize.BANNER_728x90;
            default:
                return AdSize.BANNER_320x50;
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals("setListener")) {
            adView.setBannerListener(this);
            result.success(null);
        } else if (call.method.equals("dispose")) {
            dispose();
            result.success(null);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public View getView() {
        return adView;
    }

    @Override
    public void dispose() {
        adView.destroy();
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onBannerLoad() {
        channel.invokeMethod("onBannerLoad", null);
    }

    @Override
    public void onBannerFailedToLoadProvider(String provider) {
        Map<String,Object> arguments = new HashMap<>();
        arguments.put("provider", provider);
        channel.invokeMethod("onBannerFailedToLoadProvider", arguments);
    }

    @Override
    public void onBannerFailedToLoad() {
        channel.invokeMethod("onBannerFailedToLoad", null);
    }

    @Override
    public void onBannerClicked() {
        channel.invokeMethod("onBannerClicked", null);
    }
}
