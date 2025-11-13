import 'package:flutter/material.dart';

class SequetricsBottomNav extends StatelessWidget {
  const SequetricsBottomNav({
    required this.currentRoute,
    super.key,
  });

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavItem(
        icon: Icons.home_filled,
        label: 'Home',
        route: '/dashboard',
      ),
      _NavItem(
        icon: Icons.history,
        label: 'History',
        route: '/history',
      ),
      _NavItem(
        icon: Icons.settings,
        label: 'Settings',
        route: '/settings',
      ),
    ];

    final theme = Theme.of(context);

    String normalizedRoute(String route) {
      if (route.startsWith('/analysis')) {
        return '/history';
      }
      return route;
    }

    final activeRoute = normalizedRoute(currentRoute);

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final item in items)
              _BottomNavButton(
                item: item,
                isActive: activeRoute == item.route,
                onTap: () {
                  if (activeRoute == item.route) return;
                  Navigator.of(context).pushNamed(item.route);
                },
                activeColor: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  const _BottomNavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : Colors.grey.shade600;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;
}



