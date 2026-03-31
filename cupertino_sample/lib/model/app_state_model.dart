import 'package:cupertino_sample/model/product.dart';
import 'package:cupertino_sample/repository/products_repository.dart';
import 'package:flutter/cupertino.dart';

double _salesTaxRate = 0.06;
double _shippingCostPerItem = 7;

class AppStateModel extends ChangeNotifier {
  List<Product>? _availableProducts;
  Category _selectedCategory = Category.all;
  Category get selectedCategory => _selectedCategory;

  final _productsInCart = <int, int>{};
  Map<int, int> get productsInCart => Map.from(_productsInCart);
  int get totalCartQuantity {
    return _productsInCart.values.fold(0, (accumulator, value) {
      return accumulator + value;
    });
  }

  double get subtotalCost {
    return _productsInCart.keys
        .map((id) {
          final product = getProductById(id);
          if (product == null) return 0;
          return product.price * _productsInCart[id]!;
        })
        .fold(0, (accumulator, value) => accumulator + value);
  }

  double get shippingCost => _shippingCostPerItem * totalCartQuantity;

  double get tax => subtotalCost * _salesTaxRate;
  double? get totalCost => subtotalCost + shippingCost + tax;

  List<Product> getProducts() {
    if (_availableProducts == null) {
      return [];
    }

    if (_selectedCategory == Category.all) {
      return List.from(_availableProducts!);
    } else {
      return _availableProducts!.where((p) {
        return p.category == _selectedCategory;
      }).toList();
    }
  }

  List<Product> search(String searchTerms) {
    return getProducts().where((product) {
      return product.name.toLowerCase().contains(searchTerms.toLowerCase());
    }).toList();
  }

  void addProductToCart(int productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId] = _productsInCart[productId]! + 1;
    }

    notifyListeners();
  }

  void removeItemFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId] = _productsInCart[productId]! - 1;
      }
    }

    notifyListeners();
  }

  Product? getProductById(int id) {
    return _availableProducts?.firstWhere((p) => p.id == id);
  }

  // Removes everything from the cart.
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }

  // Loads the list of available products from the repo.
  void loadProducts() {
    _availableProducts = ProductsRepository.loadProducts(Category.all);
    notifyListeners();
  }

  void setCategory(Category newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }
}
