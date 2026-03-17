import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';
import '../../auth/services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          const SizedBox(height: 16),
          // Avatar
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: const Color(0xFF7C4DFF).withAlpha(40),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 44,
                    color: Color(0xFF7C4DFF),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Alex Melody',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'user@melodify.com',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ],
            ),
          ),
          const SectionHeader('Account'),
          NavTile(
            icon: Icons.edit_rounded,
            title: 'Edit Profile',
            subtitle: '/profile/edit',
            onTap: () => context.goNamed('editProfile'),
          ),
          NavTile(
            icon: Icons.settings_rounded,
            title: 'Settings',
            subtitle: '/profile/settings',
            onTap: () => context.goNamed('settings'),
          ),
          const SectionHeader('Danger Zone'),
          NavTile(
            icon: Icons.logout_rounded,
            title: 'Log Out',
            subtitle: 'Triggers global redirect to /auth/login',
            color: Colors.redAccent,
            onTap: () async {
              await authService.logout();
            },
          ),
        ],
      ),
    );
  }
}
