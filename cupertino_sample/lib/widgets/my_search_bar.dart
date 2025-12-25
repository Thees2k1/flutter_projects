import 'package:cupertino_sample/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

class MySearchBar extends StatelessWidget {
  const MySearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Styles.searchBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            const Icon(CupertinoIcons.search, color: Styles.searchIconColor),
            Expanded(
              child: CupertinoTextField(
                decoration: BoxDecoration(color: Colors.transparent),
                controller: controller,
                focusNode: focusNode,
                style: Styles.searchText,

                cursorColor: Styles.searchCursorColor,
              ),
            ),
            GestureDetector(
              onTap: controller.clear,
              child: const Icon(
                CupertinoIcons.clear_thick_circled,
                color: Styles.searchIconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
