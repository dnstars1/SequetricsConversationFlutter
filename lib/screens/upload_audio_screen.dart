import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

import '../service/api.dart';
import '../widgets/sequetrics_app_bar.dart';
import '../widgets/sequetrics_bottom_nav.dart';

class UploadAudioScreen extends StatefulWidget {
  const UploadAudioScreen({super.key});

  @override
  State<UploadAudioScreen> createState() => _UploadAudioScreenState();
}

class _UploadAudioScreenState extends State<UploadAudioScreen> {
  File? _selectedFile;
  bool _isAnalyzing = false;
  bool _isRecording = false;

  final AudioRecorder _recorder = AudioRecorder();
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickAudioFile() async {
    if (_isAnalyzing || _isRecording) return;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      _showError('Failed to pick file: $e');
    }
  }

  Future<void> _startRecording() async {
    if (_isAnalyzing || _isRecording) return;

    try {
      if (await _recorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        final path = '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _recorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );

        setState(() {
          _isRecording = true;
        });
      } else {
        _showError('Microphone permission denied');
      }
    } catch (e) {
      _showError('Failed to start recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    try {
      final path = await _recorder.stop();

      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        setState(() {
          _selectedFile = File(path);
        });
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      _showError('Failed to stop recording: $e');
    }
  }

  Future<void> _startAnalysis() async {
    if (_selectedFile == null || _isAnalyzing) return;

    setState(() => _isAnalyzing = true);

    try {
      final result = await _apiService.voiceToText(_selectedFile!);

      if (mounted) {
        Navigator.of(context).pushNamed('/analysis/${result.id}');
      }
    } on ApiException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('Analysis failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  void _removeFile() {
    setState(() {
      _selectedFile = null;
    });
  }

  String _getFileName() {
    if (_selectedFile == null) return '';
    return _selectedFile!.path.split('/').last;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final routeName = ModalRoute.of(context)?.settings.name ?? '/upload';

    return Stack(
      children: [
        Scaffold(
          appBar: const SequetricsAppBar(
            title: 'Upload or Record Communication',
            showBack: true,
          ),
          body: SafeArea(
            child: AbsorbPointer(
              absorbing: _isAnalyzing,
              child: Opacity(
                opacity: _isAnalyzing ? 0.5 : 1.0,
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
                            backgroundColor: _isRecording
                                ? Colors.red
                                : theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            iconColor: Colors.white,
                            label: _isRecording ? 'Stop' : 'Record',
                            icon: _isRecording
                                ? Icons.stop_rounded
                                : Icons.mic_rounded,
                            onTap: _isRecording ? _stopRecording : _startRecording,
                            pulse: _isRecording,
                          ),
                          _ActionTile(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.grey.shade800,
                            iconColor: Colors.grey.shade800,
                            label: 'Upload',
                            icon: Icons.upload_rounded,
                            onTap: _pickAudioFile,
                          ),
                        ],
                      ),
                      if (_isRecording) ...[
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.fiber_manual_record,
                                  color: Colors.red,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Recording...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (_selectedFile != null) ...[
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.audiotrack_rounded,
                                  color: theme.colorScheme.primary,
                                  size: 32,
                                ),
                                const SizedBox(width: 16),
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
                                        _getFileName(),
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _startAnalysis,
                            child: const Text('Start Analysis'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: SequetricsBottomNav(currentRoute: routeName),
        ),
        if (_isAnalyzing)
          Container(
            color: Colors.black54,
            child: Center(
              child: Card(
                margin: const EdgeInsets.all(32),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 24),
                      Text(
                        'Analyzing communication...',
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This may take a few moments',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ActionTile extends StatefulWidget {
  const _ActionTile({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.iconColor,
    required this.label,
    required this.icon,
    required this.onTap,
    this.pulse = false,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color iconColor;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool pulse;

  @override
  State<_ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<_ActionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(_ActionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulse && !oldWidget.pulse) {
      _controller.repeat(reverse: true);
    } else if (!widget.pulse && oldWidget.pulse) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: widget.pulse ? _animation.value : 1.0,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
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
                  color: widget.foregroundColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.foregroundColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
