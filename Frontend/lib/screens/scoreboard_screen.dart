import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    // Load match data when screen initializes
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
              const PopupMenuItem(
                value: 'new_match',
                child: Text('New Match'),
              ),
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
          _buildScoreHeader(matchProvider),
          const SizedBox(height: 16),
          _buildCurrentBatsmen(matchProvider),
          const SizedBox(height: 16),
          _buildCurrentBowler(matchProvider),
          const SizedBox(height: 16),
          _buildCurrentOver(matchProvider),
          const SizedBox(height: 16),
          _buildScoringButtons(matchProvider),
          const SizedBox(height: 16),
          _buildExtrasButtons(matchProvider),
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
                  _buildScoreHeader(matchProvider),
                  const SizedBox(height: 16),
                  _buildCurrentBatsmen(matchProvider),
                  const SizedBox(height: 16),
                  _buildCurrentBowler(matchProvider),
                  const SizedBox(height: 16),
                  _buildCurrentOver(matchProvider),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildScoringButtons(matchProvider),
                const SizedBox(height: 16),
                _buildExtrasButtons(matchProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(MatchProvider matchProvider) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildScoreHeader(matchProvider),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: _buildCurrentBatsmen(matchProvider)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildCurrentBowler(matchProvider)),
                  ],
                ),
                const SizedBox(height: 24),
                _buildCurrentOver(matchProvider),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _buildScoringButtons(matchProvider),
                const SizedBox(height: 16),
                _buildExtrasButtons(matchProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }  W
idget _buildScoreHeader(MatchProvider matchProvider) {
    final match = matchProvider.currentMatch!;
    final innings = matchProvider.currentInnings;

    return Card(
      elevation: 4,
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
              '${match.totalOvers} Overs Match',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      '${matchProvider.totalRuns}/${matchProvider.wickets}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    Text(
                      '${matchProvider.overs}.${matchProvider.balls} overs',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'CRR: ${matchProvider.currentRunRate.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (!match.isFirstInnings) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Target: ${matchProvider.target}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'RRR: ${matchProvider.requiredRunRate.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${match.battingTeam} batting',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2, end: 0);
  }  Wid
get _buildCurrentBatsmen(MatchProvider matchProvider) {
    final innings = matchProvider.currentInnings;
    if (innings == null || innings.batsmen.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('No batsmen on field'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _showAddPlayersDialog(matchProvider),
                child: const Text('Add Players'),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
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
            ...innings.batsmen.where((b) => !b.isOut).take(2).map((batsman) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    if (batsman.isOnStrike)
                      const Icon(Icons.sports_cricket, 
                          color: AppTheme.primaryColor, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        batsman.name,
                        style: TextStyle(
                          fontWeight: batsman.isOnStrike 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    Text('${batsman.runs}(${batsman.balls})'),
                    const SizedBox(width: 8),
                    Text('SR: ${batsman.strikeRate.toStringAsFixed(1)}'),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms);
  }  
Widget _buildCurrentBowler(MatchProvider matchProvider) {
    final innings = matchProvider.currentInnings;
    if (innings == null || innings.bowlers.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('No bowler selected'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _showAddPlayersDialog(matchProvider),
                child: const Text('Add Players'),
              ),
            ],
          ),
        ),
      );
    }

    final bowler = innings.bowlers.firstWhere(
      (b) => b.isCurrentBowler,
      orElse: () => innings.bowlers.first,
    );

    return Card(
      elevation: 2,
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
                Expanded(child: Text(bowler.name)),
                Text('${bowler.oversString} overs'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('${bowler.runs}/${bowler.wickets}'),
                const Spacer(),
                Text('Econ: ${bowler.economy.toStringAsFixed(2)}'),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }  Wid
get _buildCurrentOver(MatchProvider matchProvider) {
    final overBalls = matchProvider.currentOverBalls;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Over',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (overBalls.isEmpty)
              const Text('No balls bowled in this over')
            else
              Wrap(
                spacing: 8,
                children: overBalls.map((ball) {
                  return Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: ball.isWicket 
                          ? Colors.red 
                          : ball.isExtra 
                              ? Colors.orange 
                              : AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        ball.display,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 300.ms);
  }  
Widget _buildScoringButtons(MatchProvider matchProvider) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Runs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [0, 1, 2, 3, 4, 5, 6].map((runs) {
                return ElevatedButton(
                  onPressed: () => _recordRuns(matchProvider, runs),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: runs == 4 || runs == 6 
                        ? AppTheme.accentColor 
                        : null,
                    padding: const EdgeInsets.all(8),
                  ),
                  child: Text(
                    runs.toString(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showWicketDialog(matchProvider),
                    icon: const Icon(Icons.close),
                    label: const Text('Wicket'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => matchProvider.swapStrike(),
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('Swap'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }  Wi
dget _buildExtrasButtons(MatchProvider matchProvider) {
    return Card(
      elevation: 2,
   