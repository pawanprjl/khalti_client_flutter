import 'package:flutter/services.dart';

class KhaltiClient {
  static const MethodChannel _channel = const MethodChannel('khalti_client');
  late final String publicKey;

  List<KhaltiPaymentPreference> paymentPreferences;

  KhaltiClient.configure(
      {required this.publicKey,
      this.paymentPreferences = const [
        KhaltiPaymentPreference.KHALTI,
        KhaltiPaymentPreference.CONNECT_IPS,
        KhaltiPaymentPreference.MOBILE_BANKING,
        KhaltiPaymentPreference.E_BANKING,
        KhaltiPaymentPreference.SCT,
      ]});

  void startPayment({
    required KhaltiProduct product,
    required Function(Map) onSuccess,
    required Function(Map) onFailure,
  }) async {
    _channel.invokeMethod("khalti#startPayment", {
      "publicKey": publicKey,
      "product": product.toMap(),
      "paymentPreferences": (product.paymentPreferences ?? paymentPreferences)
          .map((e) => _paymentPreferencesString[e.index])
          .toList(),
    });
    _listenToResponse(onSuccess, onFailure);
  }

  _listenToResponse(Function onSuccess, Function onFailure) {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "khalti#paymentSuccess":
          onSuccess(call.arguments);
          break;

        case "khalti#paymentError":
          onFailure(call.arguments);
          break;
        default:
      }
    });
  }
}

List<String> _paymentPreferencesString = [
  "khalti",
  "e_banking",
  "mobile_checkout",
  "connect_ips",
  "sct"
];

class KhaltiProduct {
  final String id, name, url;
  final double amount;
  final List<KhaltiPaymentPreference>? paymentPreferences;
  final Map<String, String> customData;

  KhaltiProduct({
    required this.id,
    required this.name,
    required this.amount,
    this.paymentPreferences,
    this.url = "",
    this.customData = const {},
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "url": url,
        "amount": amount,
        "customData": customData,
      };
}

enum KhaltiPaymentPreference {
  KHALTI,
  E_BANKING,
  MOBILE_BANKING,
  CONNECT_IPS,
  SCT
}
