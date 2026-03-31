import 'package:flutter/material.dart';

import 'router.dart';
import 'shared/theme/app_theme.dart';

class MelodifyApp extends StatelessWidget {
  const MelodifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Melodify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
