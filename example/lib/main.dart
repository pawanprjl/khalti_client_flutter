import 'package:flutter/material.dart';

import 'package:khalti_client/khalti_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: TextButton(
            child: Text("Pay via khalti"),
            onPressed: _payViaKhalti,
          ),
        ),
      ),
    );
  }

  _payViaKhalti() async {
    KhaltiClient _khaltiClient = KhaltiClient.configure(
      publicKey: "test_public_key_8a153ab792a64d3a88a1425209eecbf1",
      paymentPreferences: [KhaltiPaymentPreference.KHALTI],
    );

    KhaltiProduct product = KhaltiProduct(
      id: "test",
      name: "Test Product",
      amount: 1000,
    );

    _khaltiClient.startPayment(
      product: product,
      onSuccess: (data) {
        print("success");
      },
      onFailure: (data) {
        print("failure");
      },
    );
  }
}
