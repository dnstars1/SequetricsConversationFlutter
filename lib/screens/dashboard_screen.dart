import 'package:flutter/material.dart';

import '../widgets/sequetrics_app_bar.dart';
import '../widgets/sequetrics_bottom_nav.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final routeName = ModalRoute.of(context)?.settings.name ?? '/dashboard';

    Widget buildPrimaryCard({
      required IconData icon,
      required Color iconColor,
      required Color backgroundColor,
      required String title,
      required String subtitle,
      required VoidCallback onTap,
      required Widget button,
    }) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Icon(icon, color: iconColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: button,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const SequetricsAppBar(
        title: 'Sequetrics Conversation',
        showProfile: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          child: Column(
            children: [
              buildPrimaryCard(
                icon: Icons.mic_rounded,
                iconColor: Colors.white,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                title: 'Upload / Record Audio',
                subtitle: 'Analyze conversations',
                onTap: () {},
                button: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/upload'),
                  child: const Text('Start New Analysis'),
                ),
              ),
              const SizedBox(height: 16),
              buildPrimaryCard(
                icon: Icons.bar_chart_rounded,
                iconColor: theme.colorScheme.secondary,
                backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
                title: 'Recent Analyses',
                subtitle: 'View your analyses history',
                onTap: () {},
                button: OutlinedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/history'),
                  child: const Text('View All'),
                ),
              ),
              // const SizedBox(height: 16),
              // buildPrimaryCard(
              //   icon: Icons.warning_rounded,
              //   iconColor: Colors.amber.shade700,
              //   backgroundColor: Colors.amber.shade100,
              //   title: 'Active Alerts',
              //   subtitle: '2 defects detected today',
              //   onTap: () {},
              //   button: OutlinedButton(
              //     onPressed: () => Navigator.of(context).pushNamed('/history'),
              //     child: const Text('Review Alerts'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SequetricsBottomNav(currentRoute: routeName),
    );
  }
}



