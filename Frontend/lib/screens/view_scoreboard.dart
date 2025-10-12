import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/match_models.dart';
import '../providers/match_provider.dart';
import '../core/theme/app_theme.dart';

class ViewScoreBoard extends StatelessWidget {
  final List<BatsmanStats>? batsmen;
  final List<BowlerStats>? bowlers;

  const ViewScoreBoard({super.key, this.batsmen, this.bowlers});

  Widget _buildBatsmanRow(dynamic b) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              b.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text('${b.runs}')),
          Expanded(child: Text('${b.balls}')),
          Expanded(child: Text('${b.fours}')),
          Expanded(child: Text('${b.sixes}')),
          Expanded(child: Text(b.strikeRate.toStringAsFixed(2))),
        ],
      ),
    );
  }

  Widget _buildBowlerRow(dynamic b) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              b.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text('${b.overs}.${b.balls}')),
          Expanded(child: Text('${b.maidens}')),
          Expanded(child: Text('${b.runs}')),
          Expanded(child: Text('${b.wickets}')),
          Expanded(child: Text(b.economy.toStringAsFixed(2))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(
      builder: (context, matchProvider, child) {
        final currentBatsmen =
            batsmen ?? matchProvider.currentInnings?.batsmen ?? [];
        final currentBowlers =
            bowlers ?? matchProvider.currentInnings?.bowlers ?? [];
        final match = matchProvider.currentMatch;

        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Scorecard'),
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ),
            body: match == null
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sports_cricket,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No match data available',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 16.0,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Match Header
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Text(
                                    '${match.teamA} vs ${match.teamB}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (matchProvider.currentInnings != null)
                                    Text(
                                      '${matchProvider.totalRuns}/${matchProvider.wickets} (${matchProvider.overs}.${matchProvider.balls}/${match.totalOvers})',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                                  Text(
                                    '${match.battingTeam} batting',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Batsmen Section
                          const Text(
                            "Batsmen",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Name",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(child: Text("R")),
                              Expanded(child: Text("B")),
                              Expanded(child: Text("4s")),
                              Expanded(child: Text("6s")),
                              Expanded(child: Text("SR")),
                            ],
                          ),
                          const Divider(),
                          if (currentBatsmen.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('No batsmen data available'),
                            )
                          else
                            ...currentBatsmen.map(_buildBatsmanRow),

                          const SizedBox(height: 24),

                          // Bowlers Section
                          const Text(
                            "Bowlers",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Name",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(child: Text("Ov")),
                              Expanded(child: Text("M")),
                              Expanded(child: Text("R")),
                              Expanded(child: Text("W")),
                              Expanded(child: Text("Eco")),
                            ],
                          ),
                          const Divider(),
                          if (currentBowlers.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('No bowlers data available'),
                            )
                          else
                            ...currentBowlers.map(_buildBowlerRow),

                          const SizedBox(height: 24),

                          // Fall of Wickets
                          if (matchProvider
                                  .currentInnings
                                  ?.fallOfWickets
                                  .isNotEmpty ==
                              true) ...[
                            const Text(
                              "Fall of Wickets",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: matchProvider
                                      .currentInnings!
                                      .fallOfWickets
                                      .map((wicket) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  '${wicket.wickets}. ${wicket.batsmanName}',
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${wicket.runs}/${wicket.wickets}',
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${wicket.overs.toStringAsFixed(1)} ov',
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
