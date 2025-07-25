import 'package:flutter/material.dart';

class ScoreSummaryCard extends StatelessWidget {
  final List<BatsmanStats> batsmen;
  final List<BowlerStats> bowlers;
  final int strikerIndex;

  const ScoreSummaryCard({
    super.key,
    required this.batsmen,
    required this.bowlers,
    required this.strikerIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF003366),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Expanded(flex: 3, child: Text("Batsman", style: headerStyle)),
              Expanded(child: Text("R", style: headerStyle)),
              Expanded(child: Text("B", style: headerStyle)),
              Expanded(child: Text("4s", style: headerStyle)),
              Expanded(child: Text("6s", style: headerStyle)),
              Expanded(child: Text("SR", style: headerStyle)),
            ],
          ),
          const SizedBox(height: 6),
          ...batsmen.map((batsman) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        strikerIndex == batsmen.indexOf(batsman)
                            ? "${batsman.name}*" // Add asterisk for striker
                            : batsman.name,
                        style: statStyle,
                      ),
                    ),

                    Expanded(child: Text("${batsman.runs}", style: statStyle)),
                    Expanded(child: Text("${batsman.balls}", style: statStyle)),
                    Expanded(child: Text("${batsman.fours}", style: statStyle)),
                    Expanded(child: Text("${batsman.sixes}", style: statStyle)),
                    Expanded(
                      child: Text(
                        "${batsman.strikeRate.toStringAsFixed(2)}",
                        style: statStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
              ],
            );
          }),

          const Divider(color: Colors.white70),
          Row(
            children: const [
              Expanded(flex: 3, child: Text("Bowler", style: headerStyle)),
              Expanded(child: Text("O", style: headerStyle)),
              Expanded(child: Text("M", style: headerStyle)),
              Expanded(child: Text("R", style: headerStyle)),
              Expanded(child: Text("W", style: headerStyle)),
              Expanded(child: Text("Econ", style: headerStyle)),
            ],
          ),
          const SizedBox(height: 6),
          ...bowlers.map((bowler) {
            return Row(
              children: [
                Expanded(flex: 3, child: Text(bowler.name, style: statStyle)),
                Expanded(
                  child: Text(
                    "${bowler.overs}.${(bowler.totalBalls - (bowler.overs * 6)).abs()}",
                    style: statStyle,
                  ),
                ),
                Expanded(child: Text("${bowler.maidens}", style: statStyle)),
                Expanded(child: Text("${bowler.runs}", style: statStyle)),
                Expanded(child: Text("${bowler.wickets}", style: statStyle)),
                Expanded(
                  child: Text(
                    "${bowler.economy.toStringAsFixed(2)}",
                    style: statStyle,
                  ),
                ),
              ],
            );
          }),
          const Divider(color: Colors.white70),
        ],
      ),
    );
  }
}

const headerStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 13,
);

const statStyle = TextStyle(color: Colors.white, fontSize: 12);

class BatsmanStats {
  late String name;
  int runs;
  int balls;
  int fours;
  int sixes;
  double strikeRate;

  BatsmanStats({
    required this.name,
    required this.runs,
    required this.balls,
    required this.fours,
    required this.sixes,
    required this.strikeRate,
  });
}

class BowlerStats {
  late String name;
  int overs;
  int totalBalls;
  int maidens;
  int runs;
  int wickets;
  double economy;

  BowlerStats({
    required this.name,
    required this.overs,
    required this.totalBalls,
    required this.maidens,
    required this.runs,
    required this.wickets,
    required this.economy,
  });
}
