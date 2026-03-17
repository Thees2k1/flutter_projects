import 'package:flutter/material.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /profile/settings/notifications
class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _newReleases = true;
  bool _playlistUpdates = false;
  bool _promotions = true;
  bool _friendActivity = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          const SectionHeader('Push Notifications'),
          _Toggle(
            label: 'New Releases',
            value: _newReleases,
            onChanged: (v) => setState(() => _newReleases = v),
          ),
          _Toggle(
            label: 'Playlist Updates',
            value: _playlistUpdates,
            onChanged: (v) => setState(() => _playlistUpdates = v),
          ),
          _Toggle(
            label: 'Promotions',
            value: _promotions,
            onChanged: (v) => setState(() => _promotions = v),
          ),
          _Toggle(
            label: 'Friend Activity',
            value: _friendActivity,
            onChanged: (v) => setState(() => _friendActivity = v),
          ),
        ],
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF7C4DFF),
    );
  }
}
