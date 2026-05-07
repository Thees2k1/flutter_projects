import 'package:flutter/material.dart';

class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({super.key, this.onPaymentMethodSelected});

  final VoidCallback? onPaymentMethodSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      color: Colors.grey.shade400,
    );
  }
}
