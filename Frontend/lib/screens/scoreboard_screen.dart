import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../widgets/responsive_layout.dart';
import '../core/theme/app_theme.dart';

class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen({super.key});

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MatchProvider>().loadMatchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cricket Scoreboard'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<MatchProvider>().loadMatchData(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'new_match':
                  Navigator.pushReplacementNamed(context, '/match-setup');
                  break;
                case 'view_scorecard':
                  Navigator.pushNamed(context, '/view-scoreboard');
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'new_match', child: Text('New Match')),
              const PopupMenuItem(
                value: 'view_scorecard',
                child: Text('View Scorecard'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<MatchProvider>(
        builder: (context, matchProvider, child) {
          if (matchProvider.currentMatch == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sports_cricket, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No active match',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start a new match to begin scoring',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ResponsiveLayout(
            mobile: _buildMobileLayout(matchProvider),
            tablet: _buildTabletLayout(matchProvider),
            desktop: _buildDesktopLayout(matchProvider),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(MatchProvider matchProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildScoreCard(matchProvider),
          const SizedBox(height: 16),
          _buildCurrentBatsmen(matchProvider),
          const SizedBox(height: 16),
          _buildCurrentBowler(matchProvider),
          const SizedBox(height: 16),
          _buildScoringButtons(matchProvider),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(MatchProvider matchProvider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildScoreCard(matchProvider),
                  const SizedBox(height: 16),
                  _buildCurrentBatsmen(matchProvider),
                  const SizedBox(height: 16),
                  _buildCurrentBowler(matchProvider),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(flex: 3, child: _buildScoringButtons(matchProvider)),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(MatchProvider matchProvider) {
    return _buildTabletLayout(matchProvider);
  }

  Widget _buildScoreCard(MatchProvider matchProvider) {
    final match = matchProvider.currentMatch!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '${match.teamA} vs ${match.teamB}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${matchProvider.totalRuns}/${matchProvider.wickets}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            Text(
              '${matchProvider.overs}.${matchProvider.balls}/${match.totalOvers} overs',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '${match.battingTeam} batting',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            if (matchProvider.currentRunRate > 0)
              Text(
                'Run Rate: ${matchProvider.currentRunRate.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentBatsmen(MatchProvider matchProvider) {
    final batsmen = matchProvider.currentInnings?.batsmen ?? [];
    if (batsmen.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Batsmen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...batsmen.where((b) => !b.isOut).take(2).map((batsman) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    if (batsman.isOnStrike)
                      const Icon(
                        Icons.sports_cricket,
                        size: 16,
                        color: AppTheme.accentColor,
                      ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(batsman.name)),
                    Text('${batsman.runs}(${batsman.balls})'),
                    const SizedBox(width: 16),
                    Text('SR: ${batsman.strikeRate.toStringAsFixed(1)}'),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentBowler(MatchProvider matchProvider) {
    final bowlers = matchProvider.currentInnings?.bowlers ?? [];
    final currentBowler = bowlers.where((b) => b.isCurrentBowler).firstOrNull;

    if (currentBowler == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Bowler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Text(currentBowler.name)),
                Text(
                  '${currentBowler.overs}.${currentBowler.balls}-${currentBowler.maidens}-${currentBowler.runs}-${currentBowler.wickets}',
                ),
                const SizedBox(width: 16),
                Text('Eco: ${currentBowler.economy.toStringAsFixed(2)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoringButtons(MatchProvider matchProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scoring',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (int runs in [0, 1, 2, 3, 4, 6])
                  ElevatedButton(
                    onPressed: () => _recordRuns(matchProvider, runs),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: runs == 4 || runs == 6
                          ? AppTheme.accentColor
                          : AppTheme.primaryColor,
                      minimumSize: const Size(60, 60),
                    ),
                    child: Text(
                      runs.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _recordExtra(matchProvider, 'wide'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('Wide'),
                ),
                ElevatedButton(
                  onPressed: () => _recordExtra(matchProvider, 'noball'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('No Ball'),
                ),
                ElevatedButton(
                  onPressed: () => _recordExtra(matchProvider, 'bye'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Bye'),
                ),
                ElevatedButton(
                  onPressed: () => _recordExtra(matchProvider, 'legbye'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Leg Bye'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _recordWicket(matchProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Wicket'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => matchProvider.swapStrike(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Swap Strike'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _recordRuns(MatchProvider matchProvider, int runs) {
    matchProvider.recordBall(runs: runs);
  }

  void _recordExtra(MatchProvider matchProvider, String type) {
    switch (type) {
      case 'wide':
        matchProvider.recordBall(runs: 1, isWide: true);
        break;
      case 'noball':
        matchProvider.recordBall(runs: 1, isNoBall: true);
        break;
      case 'bye':
        matchProvider.recordBall(runs: 1, isBye: true);
        break;
      case 'legbye':
        matchProvider.recordBall(runs: 1, isLegBye: true);
        break;
    }
  }

  void _recordWicket(MatchProvider matchProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Record Wicket'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Bowled'),
              onTap: () {
                Navigator.pop(context);
                matchProvider.recordBall(
                  runs: 0,
                  isWicket: true,
                  wicketType: 'Bowled',
                );
              },
            ),
            ListTile(
              title: const Text('Caught'),
              onTap: () {
                Navigator.pop(context);
                matchProvider.recordBall(
                  runs: 0,
                  isWicket: true,
                  wicketType: 'Caught',
                );
              },
            ),
            ListTile(
              title: const Text('LBW'),
              onTap: () {
                Navigator.pop(context);
                matchProvider.recordBall(
                  runs: 0,
                  isWicket: true,
                  wicketType: 'LBW',
                );
              },
            ),
            ListTile(
              title: const Text('Run Out'),
              onTap: () {
                Navigator.pop(context);
                matchProvider.recordBall(
                  runs: 0,
                  isWicket: true,
                  wicketType: 'Run Out',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
