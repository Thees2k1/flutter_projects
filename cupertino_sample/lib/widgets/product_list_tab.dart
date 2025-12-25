import 'package:cupertino_sample/model/app_state_model.dart';
import 'package:cupertino_sample/widgets/product_row_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart' show Consumer;

class ProductListTab extends StatelessWidget {
  const ProductListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        final products = model.getProducts();
        return CustomScrollView(
          semanticChildCount: products.length,
          slivers: <Widget>[
            CupertinoSliverNavigationBar(largeTitle: Text('Cupertino Store')),
            SliverSafeArea(
              top: false,
              minimum: const EdgeInsets.only(top: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index < products.length) {
                    return ProductRowItem(
                      index: index,
                      product: products[index],
                      lastItem: index == products.length - 1,
                    );
                  }
                  return null;
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}
