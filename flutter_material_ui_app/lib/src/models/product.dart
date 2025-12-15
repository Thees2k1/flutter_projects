class Product {
  final int id;
  final String name;
  final double price;
  final Category category;
  final bool isFeatured;

  const Product({
    required this.id,
    required this.name,
    required this.isFeatured,
    required this.category,
    required this.price,
  });

  String get assetName => '$id-0.jpg';
  String get assetPackage => 'shrine_images';

  @override
  String toString() => "$name (id=$id)";
}

enum Category { all, accessories, clothing, home }
