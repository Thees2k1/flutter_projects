import 'package:flutter/material.dart';
import 'package:metro/constants/strings.dart';

import 'components/checkout_button_section.dart';
import 'components/payment_info_section.dart';
import 'components/payment_method_section.dart';
import 'components/product_info_section.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  static PageRoute get pageRoute =>
      MaterialPageRoute(builder: (context) => OrderPage());

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool isSelectedPaymentMethod = false;

  final topSpace = const SizedBox(height: 16);
  final gap = const SizedBox(height: 12);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(orderInfoLabelVi),
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: .symmetric(horizontal: 8),
              children: [
                topSpace,
                PaymentMethodSection(
                  onPaymentMethodSelected: () {
                    setState(() {
                      isSelectedPaymentMethod = true;
                    });
                  },
                ),
                gap,
                PaymentInfoSection(),
                gap,
                ProductInfoSection(),
              ],
            ),
          ),
          CheckoutButtonSection(disabled: !isSelectedPaymentMethod),
        ],
      ),
    );
  }
}
