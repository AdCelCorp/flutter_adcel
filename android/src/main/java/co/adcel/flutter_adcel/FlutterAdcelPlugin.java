package co.adcel.flutter_adcel;

import android.app.Activity;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import co.adcel.init.AdCel;
import co.adcel.init.AdCelInitializationListener;
import co.adcel.interstitialads.InterstitialListener;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterAdcelPlugin */
public class FlutterAdcelPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler, InterstitialListener {
  private Activity mActivity;
  private MethodChannel mChannel;

  public FlutterAdcelPlugin() {

  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    mActivity = binding.getActivity();
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
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_adcel");
    this.mChannel = channel;
    channel.setMethodCallHandler(this);
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
//  public static void registerWith(Registrar registrar) {
//    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_adcel");
//    channel.setMethodCallHandler(new FlutterAdcelPlugin(registrar.activity(), channel));
//  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (mActivity == null) {
      result.error("1", null, null);
    }
    if (call.method.equals("init") && call.hasArgument("key") && call.hasArgument("types")) {
      AdCel.setLogging(true);
      AdCel.setInterstitialListener(this);
      AdCel.initializeSDK(mActivity, call.<String>argument("key"), call.<List<String>>argument("types").toArray(new String[] {}));
      result.success(null);
    } else if (call.method.equals("showInterstitialAd") && call.hasArgument("type")) {
      AdCel.showInterstitialAd(call.<String>argument("type"));
      result.success(null);
    } else if (call.method.equals("showInterstitialAd")) {
      AdCel.showInterstitialAd();
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
    mChannel.invokeMethod("onInterstitialStarted", arguments);
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
    mChannel.invokeMethod("onInterstitialClosed", arguments);
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
