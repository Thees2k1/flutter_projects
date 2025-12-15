import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

const String _emulatorHostOverride = String.fromEnvironment(
  'EMULATOR_HOST',
  defaultValue: '',
);

String get kEmulatorHost {
  if (_emulatorHostOverride.isNotEmpty) return _emulatorHostOverride;
  if (kIsWeb) return 'localhost';
  return defaultTargetPlatform == TargetPlatform.android
      ? '10.0.2.2'
      : 'localhost';
}
