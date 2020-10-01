package co.adcel.flutter_adcel;

import android.content.Context;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class AdCelBannerFactory extends PlatformViewFactory {
    private BinaryMessenger messenger;

    public AdCelBannerFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        return new AdCelBanner(context, messenger, viewId, args);
    }
}
