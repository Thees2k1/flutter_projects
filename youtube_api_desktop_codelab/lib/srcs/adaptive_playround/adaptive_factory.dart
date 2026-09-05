import 'dart:io';

import 'package:flutter/widgets.dart';

import './material/my_material_app.dart';
import './cupertino/my_cupertino_app.dart';

class AdaptiveFactory {
  bool getIsPlatformSupported() {
    return Platform.isAndroid || Platform.isIOS;
  }

  Widget app() {
    if (!getIsPlatformSupported()) {
      throw Exception("Unsupported Device");
    }

    if (Platform.isAndroid) {
      return const MyMaterialApp();
    } else {
      return const MyCupertioApp();
    }
  }
}
