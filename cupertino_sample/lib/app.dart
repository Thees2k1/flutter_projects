import 'package:flutter/cupertino.dart';

import 'home_page.dart';

class CupertinoStoreApp extends StatelessWidget {
  const CupertinoStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(home: HomePage());
  }
}
