import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Displays current route state — path, params, query params, and extra.
/// Used on every page to make routing concepts visible while navigating.
class RouteInfoCard extends StatelessWidget {
  const RouteInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    final pathParams = state.pathParameters;
    final queryParams = state.uri.queryParameters;
    final extra = state.extra;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C4DFF).withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.route_rounded,
                    size: 16,
                    color: Color(0xFF7C4DFF),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Route Info',
                  style: TextStyle(
                    color: Color(0xFF7C4DFF),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            _InfoRow(label: 'Full URI', value: state.uri.toString()),
            _InfoRow(label: 'Matched', value: state.matchedLocation),
            if (state.name != null)
              _InfoRow(label: 'Route name', value: state.name!),
            if (pathParams.isNotEmpty)
              _InfoRow(
                label: 'Path params',
                value: pathParams.entries
                    .map((e) => ':${e.key} = ${e.value}')
                    .join('\n'),
                highlight: true,
              ),
            if (queryParams.isNotEmpty)
              _InfoRow(
                label: 'Query params',
                value: queryParams.entries
                    .map((e) => '?${e.key} = ${e.value}')
                    .join('\n'),
                highlight: true,
              ),
            if (extra != null)
              _InfoRow(
                label: 'Extra data',
                value: extra.toString(),
                highlight: true,
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: highlight
                    ? const Color(0xFF00E5FF)
                    : const Color(0xFFE8E8FF),
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A styled navigation tile used on demo pages.
class NavTile extends StatelessWidget {
  const NavTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.color = const Color(0xFF7C4DFF),
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              )
            : null,
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey.shade600,
          size: 18,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

/// Section header for page content
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
