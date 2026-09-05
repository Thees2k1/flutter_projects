import 'package:flutter/widgets.dart';

import 'app.dart';

class DragAnimationModule {
  Widget _appBuilder() {
    return MainApp();
  }

  Future<Widget> bootstrap() async {
    return _appBuilder();
  }
}
