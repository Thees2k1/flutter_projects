import 'package:cupertino_sample/model/app_state_model.dart';
import 'package:cupertino_sample/model/product.dart';
import 'package:cupertino_sample/styles.dart';
import 'package:cupertino_sample/widgets/item_image_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart' show Provider;

class ProductRowItem extends StatelessWidget {
  const ProductRowItem({
    super.key,
    required this.index,
    required this.product,
    required this.lastItem,
    this.onItemPressed,
  });

  final Product product;
  final int index;
  final bool lastItem;
  final ValueChanged? onItemPressed;

  @override
  Widget build(BuildContext context) {
    final row = SafeArea(
      top: false,
      bottom: false,
      minimum: const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 8),
      child: Row(
        children: <Widget>[
          ItemImageBox(
            product.assetName,
            width: 76,
            height: 76,
            package: product.assetPackage,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(product.name, style: Styles.productRowItemName),
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Text('\$${product.price}', style: Styles.productRowItemPrice),
                ],
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.plus_circled,
              semanticLabel: 'Add',
            ),
            onPressed: () {
              onItemPressed?.call(product.id);
              final model = Provider.of<AppStateModel>(context, listen: false);
              model.addProductToCart(product.id);
            },
          ),
        ],
      ),
    );

    if (lastItem) {
      return row;
    }

    return Column(
      children: <Widget>[
        row,
        Padding(
          padding: const EdgeInsets.only(left: 100, right: 16),
          child: Container(height: 1, color: Styles.productRowDivider),
        ),
      ],
    );
  }
}
