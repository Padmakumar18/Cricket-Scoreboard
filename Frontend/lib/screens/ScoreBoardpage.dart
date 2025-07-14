import 'package:flutter/material.dart';
import 'package:Frontend/widgets/Score.dart';

class ScoreBoardPage extends StatefulWidget {
  final String teamA;
  final String teamB;

  const ScoreBoardPage({super.key, required this.teamA, required this.teamB});

  @override
  State<ScoreBoardPage> createState() => _ScoreBoardPageState();
}

class _ScoreBoardPageState extends State<ScoreBoardPage> {
  Map<String, Map<int, String>> bowlersAndTheirOversAndRuns = {};

  String batsman1 = '';
  String batsman2 = '';
  String bowler = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Score Board Page')),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          children: [
            Center(
              child: Text(
                '${widget.teamA != "" ? widget.teamA : "Team A"} vs ${widget.teamB != "" ? widget.teamB : 'Team B'}',
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Score(number: 0), // Placeholder for team score
          ],
        ),
      ),
    );
  }
}

class Batsman {
  String batsmanName;
  int runs;
  int ballsFaced;
  int sixes;
  int fours;
  double strikeRate;
  String outStatus;

  Batsman({
    required this.batsmanName,
    required this.runs,
    required this.ballsFaced,
    required this.sixes,
    required this.fours,
    required this.strikeRate,
    required this.outStatus,
  });

  int findStrikeRate() {
    return ballsFaced == 0 ? 0 : ((runs * 100) / ballsFaced).round();
  }
}

class Bowler {
  String bowlerName;
  int overs;
  int maidens;
  int runsConceded;
  int wickets;
  double economyRate;
  Map<int, List<String>> oversAndRuns;

  Bowler({
    required this.bowlerName,
    required this.overs,
    required this.maidens,
    required this.runsConceded,
    required this.wickets,
    required this.economyRate,
    required this.oversAndRuns,
  });

  double findEconomyRate() {
    return overs == 0 ? 0 : (runsConceded / overs).toDouble();
  }
}
