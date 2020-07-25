package cn.shifen.things

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant.registerWith
import io.flutter.plugins.webviewflutter.WebViewFlutterPlugin

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        registerWith(flutterEngine);
        flutterEngine.plugins.add(BleNetworkPlugin())
    }
}
