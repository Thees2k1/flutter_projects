import 'package:cupertino_sample/error_page.dart';
import 'package:cupertino_sample/widgets/product_list_tab.dart';
import 'package:cupertino_sample/widgets/search_tab.dart';
import 'package:cupertino_sample/widgets/shopping_cart_tab.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final _tabBar = CupertinoTabBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.home),
          label: 'Product',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.search),

          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.shopping_cart),
          label: 'Cart',
        ),
      ],
    );
    return CupertinoTabScaffold(tabBar: _tabBar, tabBuilder: _tabBuilder);
  }

  Widget _tabBuilder(BuildContext context, int index) {
    switch (index) {
      case 0:
        return CupertinoTabView(
          builder: (context) {
            return CupertinoPageScaffold(child: ProductListTab());
          },
        );
      case 1:
        return CupertinoTabView(
          builder: (context) {
            return CupertinoPageScaffold(child: SearchTab());
          },
        );
      case 2:
        return CupertinoTabView(
          builder: (context) {
            return CupertinoPageScaffold(child: ShoppingCartTab());
          },
        );
      default:
        return CupertinoTabView(
          builder: (context) {
            return ErrorPage();
          },
        );
    }
  }
}
