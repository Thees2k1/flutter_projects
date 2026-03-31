import 'package:flutter/widgets.dart';

class ItemImageBox extends StatelessWidget {
  const ItemImageBox(
    this.imageName, {
    super.key,
    this.package,
    this.width = 72,
    this.height = 72,
    this.fit = BoxFit.cover,
    this.radius = 4.0,
  });

  final double width;

  final double height;
  final BoxFit fit;
  final String imageName;
  final String? package;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        imageName,
        package: package,
        fit: fit,
        width: width,
        height: height,
      ),
    );
  }
}
