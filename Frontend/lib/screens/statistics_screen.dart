import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/match_history_service.dart';
import '../services/statistics_service.dart';
import '../models/match_models.dart';

import '../core/theme/app_theme.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  final MatchHistoryService _historyService = MatchHistoryService();
  final StatisticsService _statsService = StatisticsService();

  late TabController _tabController;
  List<Match> _matches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final matches = await _historyService.getMatchHistory();
    setState(() {
      _matches = matches.where((m) => m.status == 'completed').toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: AppTheme.primaryColor,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Top Batsmen'),
            Tab(text: 'Top Bowlers'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _matches.isEmpty
          ? _buildEmptyState()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildTopBatsmenTab(),
                _buildTopBowlersTab(),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Statistics Available',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete some matches to see statistics',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final totalMatches = _matches.length;
    final totalRuns = _matches.fold<int>(
      0,
      (sum, match) =>
          sum +
          match.innings.fold<int>(
            0,
            (innerSum, innings) => innerSum + innings.totalRuns,
          ),
    );
    final totalWickets = _matches.fold<int>(
      0,
      (sum, match) =>
          sum +
          match.innings.fold<int>(
            0,
            (innerSum, innings) => innerSum + innings.wickets,
          ),
    );
    final totalFours = _matches.fold<int>(
      0,
      (sum, match) =>
          sum +
          match.innings.fold<int>(
            0,
            (innerSum, innings) =>
                innerSum +
                innings.batsmen.fold<int>(
                  0,
                  (bSum, batsman) => bSum + batsman.fours,
                ),
          ),
    );
    final totalSixes = _matches.fold<int>(
      0,
      (sum, match) =>
          sum +
          match.innings.fold<int>(
            0,
            (innerSum, innings) =>
                innerSum +
                innings.batsmen.fold<int>(
                  0,
                  (bSum, batsman) => bSum + batsman.sixes,
                ),
          ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overall Statistics',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildStatCard(
            'Total Matches',
            totalMatches.toString(),
            Icons.sports_cricket,
          ),
          _buildStatCard('Total Runs', totalRuns.toString(), Icons.trending_up),
          _buildStatCard(
            'Total Wickets',
            totalWickets.toString(),
            Icons.sports,
          ),
          _buildStatCard('Total Fours', totalFours.toString(), Icons.filter_4),
          _buildStatCard('Total Sixes', totalSixes.toString(), Icons.filter_6),
          const SizedBox(height: 24),
          _buildMatchesChart(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.accentColor.withValues(alpha: 0.2),
          child: Icon(icon, color: AppTheme.accentColor),
        ),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildMatchesChart() {
    if (_matches.length < 2) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Runs Trend',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _matches.asMap().entries.map((entry) {
                        final totalRuns = entry.value.innings.fold<int>(
                          0,
                          (sum, innings) => sum + innings.totalRuns,
                        );
                        return FlSpot(
                          entry.key.toDouble(),
                          totalRuns.toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: AppTheme.accentColor,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBatsmenTab() {
    final topBatsmen = _statsService.getTopBatsmen(_matches, limit: 10);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: topBatsmen.length,
      itemBuilder: (context, index) {
        final player = topBatsmen[index];
        return _buildPlayerCard(
          rank: index + 1,
          name: player.playerName,
          primaryStat: '${player.totalRuns} runs',
          secondaryStat: 'SR: ${player.strikeRate.toStringAsFixed(1)}',
          tertiaryStats: [
            '${player.fours} 4s',
            '${player.sixes} 6s',
            'HS: ${player.highestScore}',
          ],
        );
      },
    );
  }

  Widget _buildTopBowlersTab() {
    final topBowlers = _statsService.getTopBowlers(_matches, limit: 10);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: topBowlers.length,
      itemBuilder: (context, index) {
        final player = topBowlers[index];
        return _buildPlayerCard(
          rank: index + 1,
          name: player.playerName,
          primaryStat: '${player.wickets} wickets',
          secondaryStat: 'Econ: ${player.economy.toStringAsFixed(2)}',
          tertiaryStats: [
            'Avg: ${player.bowlingAverage.toStringAsFixed(1)}',
            'Best: ${player.bestBowling}',
          ],
        );
      },
    );
  }

  Widget _buildPlayerCard({
    required int rank,
    required String name,
    required String primaryStat,
    required String secondaryStat,
    required List<String> tertiaryStats,
  }) {
    Color rankColor;
    if (rank == 1) {
      rankColor = Colors.amber;
    } else if (rank == 2) {
      rankColor = Colors.grey[400]!;
    } else if (rank == 3) {
      rankColor = Colors.brown[300]!;
    } else {
      rankColor = AppTheme.primaryColor;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: rankColor.withValues(alpha: 0.2),
              child: Text(
                '$rank',
                style: TextStyle(color: rankColor, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    primaryStat,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    secondaryStat,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: tertiaryStats.map((stat) {
                      return Chip(
                        label: Text(stat, style: const TextStyle(fontSize: 10)),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
