import 'package:flutter/material.dart';
import '../services/match_history_service.dart';
import '../models/match_models.dart';
import '../core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class MatchHistoryScreen extends StatefulWidget {
  const MatchHistoryScreen({super.key});

  @override
  State<MatchHistoryScreen> createState() => _MatchHistoryScreenState();
}

class _MatchHistoryScreenState extends State<MatchHistoryScreen> {
  final MatchHistoryService _historyService = MatchHistoryService();
  List<Match> _matches = [];
  bool _isLoading = true;
  String _filterTeam = 'All';

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final matches = await _historyService.getMatchHistory();
    setState(() {
      _matches = matches;
      _isLoading = false;
    });
  }

  List<Match> get _filteredMatches {
    if (_filterTeam == 'All') return _matches;
    return _matches
        .where((m) => m.teamA == _filterTeam || m.teamB == _filterTeam)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match History'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear') {
                _showClearConfirmation();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_forever, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Clear History'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _matches.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                _buildFilterChips(),
                Expanded(child: _buildMatchList()),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Match History',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Completed matches will appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final teams = <String>{'All'};
    for (var match in _matches) {
      teams.add(match.teamA);
      teams.add(match.teamB);
    }

    return Container(
      padding: const EdgeInsets.all(8),
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: teams.map((team) {
          final isSelected = _filterTeam == team;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(team),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _filterTeam = team);
              },
              selectedColor: AppTheme.accentColor,
              checkmarkColor: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMatchList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredMatches.length,
      itemBuilder: (context, index) {
        final match = _filteredMatches[index];
        return _buildMatchCard(match);
      },
    );
  }

  Widget _buildMatchCard(Match match) {
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _viewMatchDetails(match),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${match.teamA} vs ${match.teamB}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildStatusBadge(match.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                dateFormat.format(match.startTime),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              if (match.result != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    match.result!,
                    style: const TextStyle(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              _buildScoreSummary(match),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;

    switch (status) {
      case 'completed':
        color = AppTheme.successColor;
        text = 'Completed';
        break;
      case 'ongoing':
        color = AppTheme.warningColor;
        text = 'Ongoing';
        break;
      default:
        color = Colors.grey;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildScoreSummary(Match match) {
    return Row(
      children: match.innings.map((innings) {
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                innings.battingTeam,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${innings.totalRuns}/${innings.wickets} (${innings.overs}.${innings.balls})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _viewMatchDetails(Match match) {
    Navigator.pushNamed(context, '/match-details', arguments: match);
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text(
          'Are you sure you want to clear all match history? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              await _historyService.clearHistory();
              navigator.pop();
              _loadHistory();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
