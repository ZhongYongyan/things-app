package cn.shifen.things;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.common.StandardMethodCodec;

//BasicMessageChannel：
//用于传递字符串和半结构化的信息，Flutter和平台端进行消息数据交换时候可以使用。
//
//MethodChannel：
//用于传递方法调用（method invocation），Flutter和平台端进行直接方法调用时候可以使用。
//
//EventChannel：
//用于数据流（event streams）的通信，Flutter和平台端进行事件监听、取消等可以使用。
public class PlatformUtil {
    public PlatformUtil(BinaryMessenger binaryMessenger) {
        this.binaryMessenger = binaryMessenger;
    }

    private BinaryMessenger binaryMessenger;

    public BasicMessageChannel createBasicMessageChannel(String key) {
        return new BasicMessageChannel<>(binaryMessenger, key, StandardMessageCodec.INSTANCE);
    }

    public MethodChannel createMethodChannel(String key) {
        return new MethodChannel(binaryMessenger, key, StandardMethodCodec.INSTANCE);
    }

    public EventChannel createEventChannel(String key) {
        return new EventChannel(binaryMessenger, key, StandardMethodCodec.INSTANCE);
    }
}