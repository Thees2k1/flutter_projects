import 'package:flutter/material.dart';
import 'package:new_flutter_temp_project/shared/context_extension.dart';

class AdaptiveText extends StatelessWidget {
  const AdaptiveText(this.data, {super.key, this.style});

  final String data;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    // switch operation
    return switch (context.theme.platform) {
      TargetPlatform.android || TargetPlatform.iOS => Text(data, style: style),
      _ => SelectableText(data, style: style),
    };
  }
}
