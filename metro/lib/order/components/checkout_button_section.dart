import 'package:flutter/material.dart';
import 'package:metro/constants/colors.dart';
import 'package:metro/constants/strings.dart';

class CheckoutButtonSection extends StatelessWidget {
  const CheckoutButtonSection({super.key, this.disabled = false});

  final bool disabled;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          checkoutDisclaimerLabelVi,
          style: const TextStyle(color: infoColor),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(),
          onPressed: disabled ? null : () => _proceedCheckout(),
          child: Text("Thanh toán: 6.000đ"),
        ),
      ],
    );
  }

  void _proceedCheckout() {}
}
