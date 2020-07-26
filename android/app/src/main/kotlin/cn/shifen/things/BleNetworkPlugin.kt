package cn.shifen.things

import android.bluetooth.BluetoothAdapter
import android.os.Build
import android.os.Handler
import android.util.Log
import androidx.annotation.NonNull
import com.aispeech.blenetwork.network.netconfig.NetworkConfigClient
import com.aispeech.blenetwork.network.netconfig.link.LinkManager
import com.aispeech.blenetwork.network.netconfig.link.ble.BleLinkManager
import com.aispeech.blenetwork.network.netconfig.scan.DeviceScanner
import com.aispeech.blenetwork.network.netconfig.scan.ScanCallback
import com.aispeech.blenetwork.network.netconfig.scan.ScanResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


public class BleNetworkPlugin : FlutterPlugin, MethodCallHandler {

    val TAG = "BleNetworkPlugin"

    private lateinit var mClient: NetworkConfigClient
    private lateinit var apLinkManager: LinkManager
    private lateinit var mDeviceScanner: DeviceScanner
    private var timeoutHandler: Handler = Handler()
    private lateinit var channel: MethodChannel
    private lateinit var platformUtil: PlatformUtil
    private var scanResults: ArrayList<ScanResult> = ArrayList()
    private lateinit var bluetoothAdapter: BluetoothAdapter

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "blenetworkplugin_plugin")
        channel.setMethodCallHandler(this);

        platformUtil = PlatformUtil(flutterPluginBinding.binaryMessenger);

        mClient = NetworkConfigClient();
        apLinkManager = BleLinkManager.getInstance(flutterPluginBinding.applicationContext)
        mDeviceScanner = DeviceScanner(flutterPluginBinding.applicationContext)
        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "blenetworkplugin_plugin")
            channel.setMethodCallHandler(BleNetworkPlugin())
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "configNetworkForRemoteDevice" -> configNetworkForRemoteDevice(call, result)
            "startScan" -> startScan(call, result)
            "stopScan" -> stopScan(call, result)
            "setup" -> setup(call, result)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }

    fun configNetworkForRemoteDevice(@NonNull call: MethodCall, @NonNull result: Result) {
        val ssid = call.argument<String>("ssid")
        val password = call.argument<String>("password")
        val name = call.argument<String>("name").orEmpty()

        Log.i(TAG, "configNetworkForRemoteDevice, ssid:$ssid, password:$password, name:$name")

        var processed = false
        var configResultCode = -999

        timeoutHandler.obtainMessage()
        timeoutHandler.postDelayed({
            Log.i(TAG, "configNetworkForRemoteDevice timeout, configResultCode: $configResultCode")
            if (configResultCode == -999) {
                result.error("timeout", "", "")
            }
            mDeviceScanner.stopScan()
        }, 15000)

        mDeviceScanner.stopScan()
        mDeviceScanner.startScan(object : ScanCallback {
            override fun onScanResults(results: List<ScanResult>) {
                Log.i(TAG, "搜索到设备 results = $results")

                val item = results.firstOrNull { scanResult -> scanResult.name.startsWith(name, true) }
                Log.i(TAG, "搜索到设备 name = $item, processed=$processed")

                if (item != null) {
                    if (!processed) {
                        processed = true
                        mDeviceScanner.stopScan()
                        Log.i(TAG, "call configNetworkForRemoteDevice")
                        mClient.configNetworkForRemoteDevice(apLinkManager, item.bluetoothDevice, ssid, password, "JsonPrivateData") { resultCode, jsonFromServer ->
                            Log.i(TAG, "configNetworkForRemoteDevice, result:${NetworkConfigClient.resultCodeToString(resultCode)}, resultCode=$resultCode, jsonFromServer=$jsonFromServer")
                            configResultCode = resultCode

                            if (resultCode == NetworkConfigClient.CONFIGURATION_SUCCESS) {
                                Log.i(TAG, "配网成功")
                                result.success("success")
                            } else {
                                Log.e(TAG, "配网失败 ")
                                result.error("error", "", "")
                            }
                        }
                    }
                }
            }

            override fun onScanFailed(errorCode: Int) {
                mDeviceScanner.stopScan()
                result.error("onScanFailed", errorCode.toString(), "");
            }
        })
    }

    fun startScan(@NonNull call: MethodCall, @NonNull result: Result) {

        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        var enable = bluetoothAdapter.isEnabled()
        if (!bluetoothAdapter.isEnabled()) {
            bluetoothAdapter.enable()
        }

        scanResults.clear()
        timeoutHandler.obtainMessage()
        timeoutHandler.postDelayed({
            Log.i(TAG, "startScan timeout")
            mDeviceScanner.stopScan()

            platformUtil.createBasicMessageChannel("stopScan").send("stopScan") { reply ->
                Log.i(TAG, "stopScan reply --" + reply.toString())
            };
        }, 60000)

        val scanResultChannel = platformUtil.createBasicMessageChannel("scanResult");

        mDeviceScanner.stopScan()
        mDeviceScanner.startScan(object : ScanCallback {
            override fun onScanResults(results: List<ScanResult>) {
                Log.i(TAG, "搜索到设备 results = $results")

                results.forEach { x ->
                    val has = scanResults.firstOrNull { y -> x.name == y.name }
                    if (has == null) {
                        scanResults.add(x)
                    }
                }
                val items = scanResults.map {
                    it.name
                }

                scanResultChannel.send(items) { reply ->
                    Log.i(TAG, "scanResult reply --" + reply.toString())
                }
            }

            override fun onScanFailed(errorCode: Int) {
                Log.i(TAG, "onScanFailed")
                mDeviceScanner.stopScan()
            }
        })
    }

    fun stopScan(@NonNull call: MethodCall, @NonNull result: Result) {
        timeoutHandler.obtainMessage()
        mDeviceScanner.stopScan()
    }

    fun setup(@NonNull call: MethodCall, @NonNull result: Result) {
        val ssid = call.argument<String>("ssid")
        val password = call.argument<String>("password")
        val name = call.argument<String>("name").orEmpty()

        val scanResult = scanResults.firstOrNull {
            it.name == name
        }

        if (scanResult == null) {
            result.error("device_not_found", "", "")
            return;
        }

        mDeviceScanner.stopScan()

        Log.i(TAG, "call configNetworkForRemoteDevice")
        mClient.configNetworkForRemoteDevice(apLinkManager, scanResult.bluetoothDevice, ssid, password, "JsonPrivateData") { resultCode, jsonFromServer ->
            Log.i(TAG, "configNetworkForRemoteDevice, result:${NetworkConfigClient.resultCodeToString(resultCode)}, resultCode=$resultCode, jsonFromServer=$jsonFromServer")

            if (resultCode == NetworkConfigClient.CONFIGURATION_SUCCESS) {
                Log.i(TAG, "配网成功")
                result.success("success")
            } else {
                Log.e(TAG, "配网失败 ")
                result.error("error", "", "")
            }
        }
    }
}
