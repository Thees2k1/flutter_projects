import 'package:flutter/material.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /profile/settings/privacy
class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _publicProfile = true;
  bool _shareListening = false;
  bool _showInSearch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          const SectionHeader('Visibility'),
          SwitchListTile(
            title: const Text('Public Profile'),
            value: _publicProfile,
            onChanged: (v) => setState(() => _publicProfile = v),
            activeColor: const Color(0xFF7C4DFF),
          ),
          SwitchListTile(
            title: const Text('Share Listening Activity'),
            value: _shareListening,
            onChanged: (v) => setState(() => _shareListening = v),
            activeColor: const Color(0xFF7C4DFF),
          ),
          SwitchListTile(
            title: const Text('Appear in Search'),
            value: _showInSearch,
            onChanged: (v) => setState(() => _showInSearch = v),
            activeColor: const Color(0xFF7C4DFF),
          ),
        ],
      ),
    );
  }
}
