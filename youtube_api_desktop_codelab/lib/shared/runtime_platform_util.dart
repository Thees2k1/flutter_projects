import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum RuntimePlatform {
  android('android'),
  iOS('ios'),
  web('web'),
  windows('windows'),
  linux('linux'),
  macOS('macos'),
  other('other_os');

  final String id;
  const RuntimePlatform(this.id);

  factory RuntimePlatform.of([BuildContext? context]) {
    if (kIsWeb) {
      return web;
    } else if (Platform.isAndroid) {
      return android;
    } else if (Platform.isIOS) {
      return iOS;
    } else if (Platform.isWindows) {
      return windows;
    } else if (Platform.isMacOS) {
      return macOS;
    } else if (Platform.isLinux) {
      return linux;
    } else {
      return other;
    }
  }
}

extension RuntimePlatformOfContextEx on BuildContext {
  RuntimePlatform get runtimePlatform => RuntimePlatform.of(this);
}

class RuntimePlatformUtil {
  // Return type added and fixed BuildContext spelling; delegate to the enum factory.
  RuntimePlatform getCurrentPlatform(BuildContext? context) {
    return RuntimePlatform.of(context);
  }
}
