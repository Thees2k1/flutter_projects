import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'adaptive_factory.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final factory = AdaptiveFactory();
  runApp(factory.app());
}
