package cn.shifen.things

import android.Manifest
import android.content.pm.PackageManager
import android.os.Handler
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant.registerWith

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        registerWith(flutterEngine);
        flutterEngine.plugins.add(BleNetworkPlugin())

        Handler().postDelayed({
            getPermission()
        }, 3000)
    }

    private val TAG = "MainActivity"

    /**
     * 解决：无法发现蓝牙设备的问题
     *
     * 对于发现新设备这个功能, 还需另外两个权限(Android M 以上版本需要显式获取授权,附授权代码):
     */
    private val ACCESS_LOCATION = 1

    private fun getPermission() {
            var permissionCheck = 0
            permissionCheck = checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION)
            permissionCheck += checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION)
            if (permissionCheck != PackageManager.PERMISSION_GRANTED) {
                //未获得权限
                requestPermissions(arrayOf(Manifest.permission.ACCESS_FINE_LOCATION,
                        Manifest.permission.ACCESS_COARSE_LOCATION),
                        ACCESS_LOCATION) // 自定义常量,任意整型
            }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        var permissionCheck = 0
        permissionCheck = checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION)
        permissionCheck += checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION)
        if (permissionCheck != PackageManager.PERMISSION_GRANTED) {
            //未获得权限
            requestPermissions(arrayOf(Manifest.permission.ACCESS_FINE_LOCATION,
                    Manifest.permission.ACCESS_COARSE_LOCATION),
                    ACCESS_LOCATION) // 自定义常量,任意整型
        }
    }
}
