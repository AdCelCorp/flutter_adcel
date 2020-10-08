package co.adcel.flutter_adcel;

import android.app.Activity;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import co.adcel.init.AdCel;
import co.adcel.interstitialads.InterstitialListener;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterAdcelPlugin */
public class FlutterAdcelPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler, InterstitialListener {
  private Activity mActivity;
  private MethodChannel mChannel;
  private FlutterPluginBinding flutterPluginBinding;

  public FlutterAdcelPlugin() {

  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    mActivity = binding.getActivity();

    flutterPluginBinding.getPlatformViewRegistry()
            .registerViewFactory("flutter_adcel/banner",
                    new AdCelBannerFactory(flutterPluginBinding.getBinaryMessenger(), mActivity));
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    mActivity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {

  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding;
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_adcel");
    this.mChannel = channel;
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (mActivity == null) {
      result.error("1", null, null);
    }
    if (call.method.equals("init") && call.hasArgument("key") && call.hasArgument("types")) {
      AdCel.setInterstitialListener(this);
      AdCel.initializeSDK(mActivity, call.<String>argument("key"), call.<List<String>>argument("types").toArray(new String[] {}));
      result.success(null);
    } else if (call.method.equals("setTestMode") && call.hasArgument("on")) {
      AdCel.setTestMode(call.<Boolean>argument("on"));
    }  else if (call.method.equals("setLogging") && call.hasArgument("on")) {
      AdCel.setLogging(call.<Boolean>argument("on"));
    } else if (call.method.equals("showInterstitialAd") && call.hasArgument("type")) {
      if (call.hasArgument("zone")) {
        AdCel.showInterstitialAd(call.<String>argument("type"), call.<String>argument("zone"));
      } else {
        AdCel.showInterstitialAd(call.<String>argument("type"));
      }
      result.success(null);
    } else if (call.method.equals("showInterstitialAd")) {
      if (call.hasArgument("zone")) {
        AdCel.showInterstitialAdForZone(call.<String>argument("zone"));
      } else {
        AdCel.showInterstitialAd();
      }
      result.success(null);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }

  @Override
  public void onFirstInterstitialLoad(String type, String provider) {
    Map<String,Object> arguments = new HashMap<>();
    arguments.put("type", type);
    arguments.put("provider", provider);
    mChannel.invokeMethod("onFirstInterstitialLoad", arguments);
  }

  @Override
  public void onInterstitialStarted(String type, String provider) {
    Map<String,Object> arguments = new HashMap<>();
    arguments.put("type", type);
    arguments.put("provider", provider);
    mChannel.invokeMethod("onInterstitialWillAppear", arguments);
  }

  @Override
  public void onInterstitialClicked(String type, String provider) {
    Map<String,Object> arguments = new HashMap<>();
    arguments.put("type", type);
    arguments.put("provider", provider);
    mChannel.invokeMethod("onInterstitialClicked", arguments);
  }

  @Override
  public void onInterstitialClosed(String type, String provider) {
    Map<String,Object> arguments = new HashMap<>();
    arguments.put("type", type);
    arguments.put("provider", provider);
    mChannel.invokeMethod("onInterstitialDidDisappear", arguments);
  }

  @Override
  public void onInterstitialFailLoad(String type, String provider) {
    Map<String,Object> arguments = new HashMap<>();
    arguments.put("type", type);
    arguments.put("provider", provider);
    mChannel.invokeMethod("onInterstitialFailLoad", arguments);
  }

  @Override
  public boolean onInterstitialFailedToShow(String type) {
    return false;
  }

  @Override
  public void onRewardedCompleted(String provider, String currencyName, String currencyValue) {
    Map<String,Object> arguments = new HashMap<>();
    arguments.put("provider", provider);
    arguments.put("currencyName", currencyName);
    arguments.put("currencyValue", currencyValue);
    mChannel.invokeMethod("onRewardedCompleted", arguments);
  }
}
