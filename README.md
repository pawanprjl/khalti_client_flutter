# khalti_client

A plugin for implementing khalti client api in flutter. This plugin is currently only supported for android.

# How to use

```
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
```

