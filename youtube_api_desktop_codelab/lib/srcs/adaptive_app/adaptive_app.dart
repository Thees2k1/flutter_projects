import 'dart:io' show Platform;
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:new_flutter_temp_project/shared/context_extension.dart';
import 'package:new_flutter_temp_project/srcs/adaptive_app/router.dart';

const kAppTitle = 'Your Playlists';

class AdaptiveApp extends StatelessWidget {
  const AdaptiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: kAppTitle,
      theme: FlexColorScheme.light(scheme: FlexScheme.red).toTheme,
      darkTheme: FlexColorScheme.dark(scheme: FlexScheme.red).toTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

class ResizeablePage extends StatelessWidget {
  const ResizeablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final themePlatform = context.theme.platform;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Window properties',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 350,
              child: Table(
                textBaseline: TextBaseline.alphabetic,
                children: [
                  _fillTableRow(
                    context: context,
                    property: 'Window Size',
                    value:
                        '${mediaQuery.size.width.toStringAsFixed(1)} x '
                        '${mediaQuery.size.height.toStringAsFixed(1)}',
                  ),
                  _fillTableRow(
                    context: context,
                    property: 'Device Pixel Ratio',
                    value: mediaQuery.devicePixelRatio.toStringAsFixed(2),
                  ),
                  _fillTableRow(
                    context: context,
                    property: 'Platform.isXXX',
                    value: platformDescription(),
                  ),
                  _fillTableRow(
                    context: context,
                    property: 'Theme.of(context).platform',
                    value: themePlatform.toString(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _fillTableRow({
    required BuildContext context,
    required String property,
    required String value,
  }) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.baseline,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(property),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.baseline,
          child: Padding(padding: EdgeInsets.all(8), child: Text(value)),
        ),
      ],
    );
  }

  String platformDescription() {
    if (kIsWeb) {
      return 'Web';
    } else if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'iOS';
    } else if (Platform.isWindows) {
      return 'Windows';
    } else if (Platform.isMacOS) {
      return 'macOS';
    } else if (Platform.isLinux) {
      return 'Linux';
    } else if (Platform.isFuchsia) {
      return 'Fuchsia';
    } else {
      return 'Unknown';
    }
  }
}
