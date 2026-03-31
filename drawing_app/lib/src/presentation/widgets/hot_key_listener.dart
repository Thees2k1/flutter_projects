import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

class HotKeyListener extends StatefulWidget {
  final Widget child;
  final VoidCallback? onUndo;
  final VoidCallback? onRedo;
  final VoidCallback? onChangeTool;
  final ValueChanged<bool>? onShiftPressed;

  const HotKeyListener({
    super.key,
    required this.child,
    this.onUndo,
    this.onRedo,
    this.onChangeTool,
    this.onShiftPressed,
  });

  @override
  State<HotKeyListener> createState() => _HotKeyListenerState();
}

class _HotKeyListenerState extends State<HotKeyListener> {
  final FocusNode _focusNode = FocusNode()..requestFocus();
  final isMacOS = UniversalPlatform.isMacOS;

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        SingleActivator(
          LogicalKeyboardKey.keyZ,
          control: !isMacOS,
          meta: isMacOS,
        ): () {
          widget.onUndo?.call();
        },
        SingleActivator(
          LogicalKeyboardKey.keyY,
          control: !isMacOS,
          meta: isMacOS,
        ): () {
          widget.onRedo?.call();
        },
      },
      child: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: _handleKey,
        child: widget.child,
      ),
    );
  }

  void _handleKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.shiftLeft ||
          event.logicalKey == LogicalKeyboardKey.shiftRight) {
        widget.onShiftPressed?.call(true);
      } else if (event is KeyUpEvent) {
        if (event.logicalKey == LogicalKeyboardKey.shiftLeft ||
            event.logicalKey == LogicalKeyboardKey.shiftRight) {
          widget.onShiftPressed?.call(false);
        }
      }
    }
  }
}
