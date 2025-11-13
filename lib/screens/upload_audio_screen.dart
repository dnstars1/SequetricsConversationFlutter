import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/sequetrics_app_bar.dart';
import '../widgets/sequetrics_bottom_nav.dart';

class UploadAudioScreen extends StatefulWidget {
  const UploadAudioScreen({super.key});

  @override
  State<UploadAudioScreen> createState() => _UploadAudioScreenState();
}

class _UploadAudioScreenState extends State<UploadAudioScreen> {
  String? _selectedFile;
  bool _isAnalyzing = false;
  double _progress = 0;
  Timer? _timer;

  void _simulateSelection(String fileName) {
    setState(() {
      _selectedFile = fileName;
    });
  }

  void _startAnalysis() {
    if (_selectedFile == null) return;

    setState(() {
      _isAnalyzing = true;
      _progress = 0;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        _progress += 0.1;
        if (_progress >= 1) {
          _progress = 1;
          _timer?.cancel();
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!mounted) return;
            Navigator.of(context).pushNamed('/analysis/1');
          });
        }
      });
    });
  }

  void _removeFile() {
    setState(() {
      _selectedFile = null;
      _isAnalyzing = false;
      _progress = 0;
    });
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final routeName = ModalRoute.of(context)?.settings.name ?? '/upload';

    return Scaffold(
      appBar: const SequetricsAppBar(
        title: 'Upload or Record Communication',
        showBack: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _ActionTile(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    iconColor: Colors.white,
                    label: 'Record',
                    icon: Icons.mic_rounded,
                    onTap: () => _simulateSelection(
                      'recorded_comm_2025-10-17_15-45.wav',
                    ),
                  ),
                  _ActionTile(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.grey.shade800,
                    iconColor: Colors.grey.shade800,
                    label: 'Upload',
                    icon: Icons.upload_rounded,
                    onTap: () => _simulateSelection(
                      'runway_comm_2025-10-17_14-30.wav',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_selectedFile != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Selected File',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedFile!,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Duration: 2:34',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: _removeFile,
                        ),
                      ],
                    ),
                  ),
                ),
              if (_selectedFile != null && !_isAnalyzing) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startAnalysis,
                    child: const Text('Start Analysis'),
                  ),
                ),
              ],
              if (_isAnalyzing) ...[
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Text('Analyzing communication...'),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: _progress,
                          minHeight: 8,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${(_progress * 100).round()}%',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: SequetricsBottomNav(currentRoute: routeName),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.iconColor,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color iconColor;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: foregroundColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



