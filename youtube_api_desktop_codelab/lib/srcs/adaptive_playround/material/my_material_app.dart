import 'package:flutter/material.dart';
import '../../adaptive_playround/shared/styles.dart';

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: Center(
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusGeometry.circular(20),
                color: Colors.blueGrey,
              ),
            ),
          ),
          title: const ProgressRow(),
          actions: [
            NotificantionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'No notifications found',
                      style: StyleConfig.caption.style,
                      textAlign: StyleConfig.caption.textAlign,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressRow extends StatelessWidget {
  const ProgressRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: .spaceEvenly,
      children: [EnegyTile(energyCount: 234), StreakTile(streakCount: 12)],
    );
  }
}

class EnegyTile extends StatelessWidget {
  const EnegyTile({super.key, this.energyCount = 0});

  final int energyCount;

  @override
  Widget build(BuildContext context) {
    const typo = StyleConfig.bodySemiBold;
    return Tile(
      leading: const Icon(Icons.token, color: ColorConfig.energyBlue),
      label: Text(
        '$energyCount',
        textAlign: typo.textAlign,
        style: typo.style.copyWith(color: ColorConfig.energyBlue),
      ),
    );
  }
}

class StreakTile extends StatelessWidget {
  const StreakTile({super.key, this.streakCount = 0});

  final int streakCount;

  @override
  Widget build(BuildContext context) {
    return Tile(
      leading: const Icon(Icons.whatshot, color: ColorConfig.flameOrange),
      label: Text(
        '$streakCount',
        textAlign: StyleConfig.bodySemiBold.textAlign,
        style: StyleConfig.bodySemiBold.style.copyWith(
          color: ColorConfig.flameOrange,
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    super.key,
    this.gap = 4.0,
    required this.leading,
    required this.label,
  });

  final Widget leading;
  final Widget label;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final gapW = SizedBox(width: gap);
    return Row(children: [leading, gapW, label]);
  }
}

class NotificantionButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const NotificantionButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.notifications_none),
      onPressed: onPressed,
    );
  }
}
