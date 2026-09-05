import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

import '../../shared/widgets/layout_bar.dart';
import 'responsive_app.dart';

class ResponsiveAppWrapper extends StatelessWidget {
  const ResponsiveAppWrapper({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Layout(
      child: MaterialApp(
        title: 'NFTP',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        builder: (context, child) {
          return Column(
            crossAxisAlignment: .stretch,
            children: [
              Expanded(child: child!),
              LayoutBar(),
            ],
          );
        },
        home: const ResponsiveApp(title: 'Responsive app demo'),
      ),
    );
  }
}
