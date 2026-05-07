class PaymentDetail {
  final String productName = "Vé lượt: Văn Thánh - Tân Cảng";
  final double price = 6000.0;
  final currencySymbol = "đ";
  final quanity = 1;
  double get totalAmount => price * quanity;

  String getPriceString(double price) => "${price.floor()}$currencySymbol";
}
