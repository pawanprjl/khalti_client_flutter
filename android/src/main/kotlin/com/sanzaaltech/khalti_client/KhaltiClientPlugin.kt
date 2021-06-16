package com.sanzaaltech.khalti_client

import android.app.Activity
import androidx.annotation.NonNull
import com.khalti.checkout.helper.Config
import com.khalti.checkout.helper.KhaltiCheckOut
import com.khalti.checkout.helper.OnCheckOutListener
import com.khalti.checkout.helper.PaymentPreference

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.Exception

/** KhaltiClientPlugin */
class KhaltiClientPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Activity

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "khalti_client")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "khalti#startPayment" -> {
                startPayment(call)
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun startPayment(call: MethodCall) {
        val message = call.arguments as HashMap<*, *>
        val publicKey: String = message["publicKey"] as String
        val product: HashMap<String, Any> = message["product"] as HashMap<String, Any>
        val paymentPreferences: List<PaymentPreference> = (message["paymentPreferences"] as List<String>).map {
            getPreference(it)
        }

        val builder = Config.Builder(
                publicKey,
                product["id"] as String,
                product["name"] as String,
                (product["amount"] as Double).toLong(),
                object : OnCheckOutListener {
                    override fun onSuccess(data: MutableMap<String, Any>) {
                        channel.invokeMethod("khalti#paymentSuccess", data)
                    }

                    override fun onError(action: String, errorMap: MutableMap<String, String>) {
                        val errorMessage: HashMap<String, String> = HashMap()
                        errorMessage["action"] = action
                        errorMessage["message"] = errorMap.toString()
                        channel.invokeMethod("khalti#paymentError", errorMessage)
                    }
                }
        )
                .paymentPreferences(paymentPreferences)
                .additionalData(product["customData"] as HashMap<String, Any>)
                .productUrl(product["url"] as String)

        val khaltiCheckout = KhaltiCheckOut(context, builder.build())
        context.runOnUiThread {
            khaltiCheckout.show()
        }
    }

    private fun getPreference(type: String): PaymentPreference {
        when (type) {
            "khalti" -> return PaymentPreference.KHALTI
            "e_banking" -> return PaymentPreference.EBANKING
            "mobile_checkout" -> return PaymentPreference.MOBILE_BANKING
            "connect_ips" -> return PaymentPreference.CONNECT_IPS
            "sct" -> return PaymentPreference.SCT
        }
        throw Exception("Invalid Khalti payment type")
    }
}
