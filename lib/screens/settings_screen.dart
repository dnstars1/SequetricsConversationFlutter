import 'package:flutter/material.dart';

import '../widgets/sequetrics_app_bar.dart';
import '../widgets/sequetrics_bottom_nav.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _dataRetention = true;
  String _audioQuality = 'high';

  void _logout() {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name ?? '/settings';
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const SequetricsAppBar(title: 'Settings'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Icon(
                          Icons.person,
                          color: theme.colorScheme.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Guest User'),
                            SizedBox(height: 4),
                            Text(
                              'guest@sequetrics.com',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Audio Settings',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Recording Quality',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _audioQuality,
                        items: const [
                          DropdownMenuItem(
                            value: 'low',
                            child: Text('Low (8kHz)'),
                          ),
                          DropdownMenuItem(
                            value: 'medium',
                            child: Text('Medium (16kHz)'),
                          ),
                          DropdownMenuItem(
                            value: 'high',
                            child: Text('High (44.1kHz)'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _audioQuality = value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data & Privacy',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Local Data Retention',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Keep analysis history on device',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _dataRetention,
                            onChanged: (value) =>
                                setState(() => _dataRetention = value),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'About',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8),
                      Text('Sequetrics Conversation'),
                      SizedBox(height: 4),
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Professional conversation analysis platform',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                  ),
                  onPressed: _logout,
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SequetricsBottomNav(currentRoute: routeName),
    );
  }
}
