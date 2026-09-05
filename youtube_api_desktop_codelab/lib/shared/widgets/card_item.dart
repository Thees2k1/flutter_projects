import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

class CardItem extends StatelessWidget {
  final int index;

  const CardItem({super.key, required this.index});
  @override
  Widget build(BuildContext context) {
    final responsiveCardDecoration = BreakpointValue(
      xs: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      sm: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
    return Container(
      decoration: responsiveCardDecoration.resolve(context),
      alignment: Alignment.center,
      child: Text('Item $index'),
    );
  }
}
