import 'package:flutter/material.dart';

import '../widgets/sequetrics_app_bar.dart';
import '../widgets/sequetrics_bottom_nav.dart';

class AnalysisResultScreen extends StatelessWidget {
  const AnalysisResultScreen({
    required this.analysisId,
    super.key,
  });

  final String analysisId;

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeName =
        ModalRoute.of(context)?.settings.name ?? '/analysis/$analysisId';
    final theme = Theme.of(context);

    return Scaffold(
      appBar: SequetricsAppBar(
        title: 'Analysis Results',
        showBack: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          child: Column(
            children: [
              Card(
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.amber, width: 4),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_rounded,
                        color: Colors.amber,
                        size: 28,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Possible Defect Mention Detected',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Analysis identified potential runway surface issue',
                              style: TextStyle(fontSize: 13),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade100,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                '92% confidence match',
                                style: TextStyle(
                                  color: Color(0xFF92400E),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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
                        'Transcript',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            _TranscriptLine(
                              timestamp: '[00:12]',
                              speaker: 'Tower',
                              text:
                                  '"Alpha-Bravo-123, cleared for takeoff runway 27L"',
                            ),
                            _TranscriptLine(
                              timestamp: '[00:18]',
                              speaker: 'AB-123',
                              text:
                                  '"Cleared for takeoff 27L, Alpha-Bravo-123"',
                            ),
                            _TranscriptLine(
                              timestamp: '[00:45]',
                              speaker: 'AB-123',
                              text:
                                  '"Tower, Alpha-Bravo-123, we\'re seeing debris on the runway surface, approximately 1000 feet ahead"',
                              highlight:
                                  'we\'re seeing debris on the runway surface',
                            ),
                            _TranscriptLine(
                              timestamp: '[00:52]',
                              speaker: 'Tower',
                              text:
                                  '"Alpha-Bravo-123, abort takeoff, abort takeoff"',
                            ),
                            _TranscriptLine(
                              timestamp: '[00:55]',
                              speaker: 'AB-123',
                              text: '"Aborting takeoff, Alpha-Bravo-123"',
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
                        'Proposed Actions',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      const _ActionTile(
                        icon: Icons.check_circle_rounded,
                        iconColor: Color(0xFF2563EB),
                        backgroundColor: Color(0xFFDBEAFE),
                        title: 'Dispatch inspection crew to runway 27L',
                        subtitle: 'Priority: High',
                      ),
                      const SizedBox(height: 12),
                      const _ActionTile(
                        icon: Icons.warning_rounded,
                        iconColor: Color(0xFFD97706),
                        backgroundColor: Color(0xFFFDE68A),
                        title: 'Close runway 27L temporarily',
                        subtitle: 'Until inspection complete',
                      ),
                      const SizedBox(height: 12),
                      _ActionTile(
                        icon: Icons.assignment_turned_in_rounded,
                        iconColor: Colors.grey.shade700,
                        backgroundColor: Colors.grey.shade200,
                        title: 'Log incident in safety management system',
                        subtitle: 'Required documentation',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _showSnack(context, 'Analysis saved to history'),
                      icon: const Icon(Icons.save_rounded),
                      label: const Text('Save'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _showSnack(context, 'PDF exported successfully'),
                      icon: const Icon(Icons.file_download_rounded),
                      label: const Text('Export PDF'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _showSnack(context, 'Share link copied to clipboard'),
                      icon: const Icon(Icons.share_rounded),
                      label: const Text('Share'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SequetricsBottomNav(currentRoute: routeName),
    );
  }
}

class _TranscriptLine extends StatelessWidget {
  const _TranscriptLine({
    required this.timestamp,
    required this.speaker,
    required this.text,
    this.highlight,
  });

  final String timestamp;
  final String speaker;
  final String text;
  final String? highlight;

  @override
  Widget build(BuildContext context) {
    TextSpan buildTextSpan() {
      if (highlight == null) {
        return TextSpan(text: '$speaker: $text');
      }

      final startIndex = text.indexOf(highlight!);
      if (startIndex == -1) {
        return TextSpan(text: '$speaker: $text');
      }

      return TextSpan(
        children: [
          TextSpan(text: '${text.substring(0, startIndex)}'),
          TextSpan(
            text: highlight,
            style: const TextStyle(
              backgroundColor: Color(0xFFFDE68A),
              color: Colors.black,
            ),
          ),
          TextSpan(text: text.substring(startIndex + highlight!.length)),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
          ),
          children: [
            TextSpan(
              text: '$timestamp ',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
            TextSpan(text: '$speaker: '),
            buildTextSpan(),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



