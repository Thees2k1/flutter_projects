import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /profile/edit
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          const SectionHeader('Profile Info'),
          TextFormField(
            initialValue: 'Alex Melody',
            decoration: const InputDecoration(labelText: 'Display Name'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: 'user@melodify.com',
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
