import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:metro/constants/colors.dart';

import '../constants/strings.dart';

class PaymentMethod {
  final int id;
  final String name;
  final IconData icon;
  final Color? branding;
  final String? description;

  const PaymentMethod({
    required this.id,
    required this.name,
    this.icon = Icons.payment_outlined,
    this.branding,
    this.description,
  });

  Icon get paymentIcon => Icon(icon, color: branding);
}

const paymentMethods = [
  PaymentMethod(
    id: 1,
    name: internationalCardNameVi,
    branding: internationalCardBrandingcolor,
    description: "Mastercard/Visa/JCB",
  ),
  PaymentMethod(id: 2, name: momoNameVi, branding: momoBrandingcolor),
  PaymentMethod(
    id: 3,
    name: shopeePayoNameVi,
    branding: shopeePayBrandingcolor,
  ),
  PaymentMethod(id: 4, name: zaloPayNameVi, branding: zaloPayBrandingColor),
];
