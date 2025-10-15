import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/match_provider.dart';
import '../widgets/responsive_layout.dart';
import '../core/theme/app_theme.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load any saved match data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MatchProvider>().loadMatchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, constraints, deviceType) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppTheme.backgroundColor, AppTheme.surfaceColor],
              ),
            ),
            child: SafeArea(
              child: ResponsiveContainer(
                child: Column(
                  children: [
                    _buildHeader(deviceType),
                    Expanded(child: _buildContent(context, deviceType)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(DeviceType deviceType) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: deviceType == DeviceType.mobile ? 20 : 32,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cricket Scoreboard',
                style: TextStyle(
                  fontSize: deviceType == DeviceType.mobile ? 24 : 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.3),
              IconButton(
                onPressed: () {
                  themeNotifier.value = themeNotifier.value == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                },
                icon: Icon(
                  themeNotifier.value == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: Colors.white,
                  size: deviceType == DeviceType.mobile ? 24 : 28,
                ),
              ).animate().fadeIn(delay: 300.ms),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Professional Cricket Scoring Made Simple',
            style: TextStyle(
              fontSize: deviceType == DeviceType.mobile ? 14 : 16,
              color: Colors.white70,
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, DeviceType deviceType) {
    return Consumer<MatchProvider>(
      builder: (context, matchProvider, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (matchProvider.currentMatch != null) ...[
                _buildCurrentMatchCard(context, matchProvider, deviceType),
                const SizedBox(height: 24),
              ],
              _buildActionCards(context, matchProvider, deviceType),
              const SizedBox(height: 32),
              _buildFeaturesList(deviceType),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentMatchCard(
    BuildContext context,
    MatchProvider matchProvider,
    DeviceType deviceType,
  ) {
    final match = matchProvider.currentMatch!;
    final innings = matchProvider.currentInnings;

    return ResponsiveCard(
      color: AppTheme.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Match',
                style: TextStyle(
                  fontSize: deviceType == DeviceType.mobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: match.status == 'ongoing'
                      ? AppTheme.successColor
                      : AppTheme.warningColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  match.status.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${match.teamA} vs ${match.teamB}',
            style: TextStyle(
              fontSize: deviceType == DeviceType.mobile ? 16 : 18,
              color: Colors.white70,
            ),
          ),
          if (innings != null) ...[
            const SizedBox(height: 8),
            Text(
              '${innings.totalRuns}/${innings.wickets} (${innings.overs}.${innings.balls}/${match.totalOvers})',
              style: TextStyle(
                fontSize: deviceType == DeviceType.mobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentColor,
              ),
            ),
            Text(
              '${match.battingTeam} batting',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/scoreboard'),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Continue'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/view-scoreboard'),
                  icon: const Icon(Icons.assessment),
                  label: const Text('View Scorecard'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3);
  }

  Widget _buildActionCards(
    BuildContext context,
    MatchProvider matchProvider,
    DeviceType deviceType,
  ) {
    final actions = [
      {
        'title': 'New Match',
        'subtitle': 'Start a fresh cricket match',
        'icon': Icons.add_circle_outline,
        'color': AppTheme.primaryColor,
        'onTap': () => Navigator.pushNamed(context, '/match-setup'),
      },
      if (matchProvider.currentMatch != null)
        {
          'title': 'Resume Match',
          'subtitle': 'Continue current match',
          'icon': Icons.play_circle_outline,
          'color': AppTheme.successColor,
          'onTap': () => Navigator.pushNamed(context, '/scoreboard'),
        },
      {
        'title': 'Match History',
        'subtitle': 'View past matches',
        'icon': Icons.history,
        'color': AppTheme.warningColor,
        'onTap': () => Navigator.pushNamed(context, '/match-history'),
      },
      {
        'title': 'Statistics',
        'subtitle': 'Player & team stats',
        'icon': Icons.bar_chart,
        'color': AppTheme.accentColor,
        'onTap': () => Navigator.pushNamed(context, '/statistics'),
      },
    ];

    return ResponsiveGrid(
      forceColumns: deviceType == DeviceType.mobile ? 1 : 2,
      children: actions.asMap().entries.map((entry) {
        final index = entry.key;
        final action = entry.value;

        return _buildActionCard(
              title: action['title'] as String,
              subtitle: action['subtitle'] as String,
              icon: action['icon'] as IconData,
              color: action['color'] as Color,
              onTap: action['onTap'] as VoidCallback,
              deviceType: deviceType,
            )
            .animate(delay: Duration(milliseconds: 200 * index))
            .fadeIn(duration: 500.ms)
            .slideX(begin: 0.3);
      }).toList(),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required DeviceType deviceType,
  }) {
    return ResponsiveCard(
      color: AppTheme.cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(deviceType == DeviceType.mobile ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: deviceType == DeviceType.mobile ? 24 : 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: deviceType == DeviceType.mobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesList(DeviceType deviceType) {
    final features = [
      'Live score tracking with ball-by-ball commentary',
      'Comprehensive batting and bowling statistics',
      'Fall of wickets and partnership tracking',
      'Over-by-over breakdown and analysis',
      'Responsive design for all devices',
      'Local data storage and match history',
    ];

    return ResponsiveCard(
      color: AppTheme.cardColor.withValues(alpha: 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Features',
            style: TextStyle(
              fontSize: deviceType == DeviceType.mobile ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...features.asMap().entries.map((entry) {
            final index = entry.key;
            final feature = entry.value;

            return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6, right: 12),
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppTheme.accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .animate(delay: Duration(milliseconds: 100 * index))
                .fadeIn(duration: 400.ms)
                .slideX(begin: 0.2);
          }),
        ],
      ),
    );
  }
}
