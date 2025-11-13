import 'package:flutter/material.dart';

import '../widgets/sequetrics_app_bar.dart';
import '../widgets/sequetrics_bottom_nav.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  static const _historyItems = [
    HistoryItem(
      id: '1',
      dateTime: '2025-10-17 14:30',
      fileName: 'runway_comm_2025-10-17_14-30.wav',
      status: HistoryStatus.warning,
      summary: 'Debris detected on runway 27L',
    ),
    HistoryItem(
      id: '2',
      dateTime: '2025-10-17 09:15',
      fileName: 'runway_comm_2025-10-17_09-15.wav',
      status: HistoryStatus.clear,
      summary: 'No issues detected',
    ),
    HistoryItem(
      id: '3',
      dateTime: '2025-10-16 16:45',
      fileName: 'runway_comm_2025-10-16_16-45.wav',
      status: HistoryStatus.warning,
      summary: 'Weather-related communication anomaly',
    ),
    HistoryItem(
      id: '4',
      dateTime: '2025-10-16 11:20',
      fileName: 'runway_comm_2025-10-16_11-20.wav',
      status: HistoryStatus.clear,
      summary: 'No issues detected',
    ),
    HistoryItem(
      id: '5',
      dateTime: '2025-10-15 13:00',
      fileName: 'runway_comm_2025-10-15_13-00.wav',
      status: HistoryStatus.clear,
      summary: 'No issues detected',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase();
    final filteredItems = _historyItems.where((item) {
      return item.fileName.toLowerCase().contains(query) ||
          item.summary.toLowerCase().contains(query);
    }).toList();

    final routeName = ModalRoute.of(context)?.settings.name ?? '/history';

    return Scaffold(
      appBar: const SequetricsAppBar(
        title: 'Analysis History',
        showBack: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search history...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filteredItems.isEmpty
                    ? const Center(
                        child: Text(
                          'No results found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushNamed('/analysis/${item.id}'),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      item.status == HistoryStatus.warning
                                          ? Icons.warning_rounded
                                          : Icons.check_circle_rounded,
                                      color:
                                          item.status == HistoryStatus.warning
                                              ? Colors.amber.shade700
                                              : Colors.green.shade600,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.dateTime,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            item.fileName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item.summary,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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

class HistoryItem {
  const HistoryItem({
    required this.id,
    required this.dateTime,
    required this.fileName,
    required this.status,
    required this.summary,
  });

  final String id;
  final String dateTime;
  final String fileName;
  final HistoryStatus status;
  final String summary;
}

enum HistoryStatus {
  warning,
  clear,
}
