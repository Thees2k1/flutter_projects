import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /profile/settings
/// Named: 'settings'
///
/// Parent route for three settings sub-routes.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          const SectionHeader('Preferences'),
          NavTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: '/profile/settings/notifications',
            onTap: () => context.goNamed('notificationSettings'),
          ),
          NavTile(
            icon: Icons.lock_outline_rounded,
            title: 'Privacy',
            subtitle: '/profile/settings/privacy',
            onTap: () => context.goNamed('privacySettings'),
          ),
          NavTile(
            icon: Icons.workspace_premium_rounded,
            title: 'Subscription',
            subtitle: '/profile/settings/subscription',
            color: const Color(0xFFFFD60A),
            onTap: () => context.goNamed('subscription'),
          ),
        ],
      ),
    );
  }
}
