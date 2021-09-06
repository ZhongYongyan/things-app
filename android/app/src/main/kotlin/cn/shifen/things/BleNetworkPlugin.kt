package cn.shifen.things

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.content.Context
import android.os.Handler
import android.os.Message
import android.util.Log
import androidx.annotation.NonNull
import com.aispeech.blenetwork.network.netconfig.NetworkConfigClient
import com.aispeech.blenetwork.network.netconfig.link.LinkManager
import com.aispeech.blenetwork.network.netconfig.link.ble.BleLinkManager
import com.aispeech.blenetwork.network.netconfig.link.softAp.SoftApLinkManager
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
    private lateinit var softApLinkManager: SoftApLinkManager
    private lateinit var mDeviceScanner: DeviceScanner
    private var timeoutHandler: Handler = Handler()
    private lateinit var channel: MethodChannel
    private lateinit var platformUtil: PlatformUtil
    private var scanResults: ArrayList<ScanResult> = ArrayList()
    private lateinit var mHandler: NetworkConfigHandler

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "blenetworkplugin_plugin")
        channel.setMethodCallHandler(this);

        platformUtil = PlatformUtil(flutterPluginBinding.binaryMessenger);

        mClient = NetworkConfigClient();
        apLinkManager = BleLinkManager.getInstance(flutterPluginBinding.applicationContext)
        softApLinkManager = SoftApLinkManager.getInstance(flutterPluginBinding.applicationContext)
        mDeviceScanner = DeviceScanner(flutterPluginBinding.applicationContext)

        mHandler = NetworkConfigHandler(flutterPluginBinding.applicationContext)
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
            "currentNetworkSSID"->currentNetworkSSID(call, result)
            "startScan" -> startScan(call, result)
            "stopScan" -> stopScan(call, result)
            "setup" -> setup(call, result)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }

    fun currentNetworkSSID(@NonNull call: MethodCall, @NonNull result: Result){
        val ssid = softApLinkManager.currentNetworkSSID
        result.success(ssid)
    }

    fun startScan(@NonNull call: MethodCall, @NonNull result: Result) {
        scanResults.clear()
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
                val items = scanResults.filter { it.name != null && it.name.startsWith("A1") }.map {
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
            val msg = Message()
            msg.what = NetworkConfigHandlers.configNetworkForRemoteDeviceResult
            msg.arg1 = resultCode
            msg.obj = result
            mHandler.sendMessage(msg)


        }
    }

    object NetworkConfigHandlers {
        val configNetworkForRemoteDeviceResult = 1
    }

    private class NetworkConfigHandler constructor(private val mContext: Context) : Handler() {
        val TAG = "NetworkConfigHandler"
        private val mDevice: BluetoothDevice? = null
        override fun handleMessage(msg: Message) {
            when (msg.what) {
                NetworkConfigHandlers.configNetworkForRemoteDeviceResult -> {
                    val resultCode = msg.arg1
                    val result = msg.obj as Result
                    if (resultCode == NetworkConfigClient.CONFIGURATION_SUCCESS) {
                        Log.i(TAG, "配网成功")
                        result.success("success")
                    } else {
                        Log.e(TAG, "配网失败 ")
                        result.error("error", "", "")
                    }
                }
                else -> {
                }
            }
        }

    }

}
