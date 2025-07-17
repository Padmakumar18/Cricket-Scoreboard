import 'package:flutter/material.dart';
import 'package:Frontend/widgets/ScoreSummaryCard.dart';

class ScoreBoardPage extends StatefulWidget {
  final String teamA;
  final String teamB;
  final String battingTeam;
  final String bowlingTeam;
  final bool isFirstInnings;

  const ScoreBoardPage({
    super.key,
    required this.teamA,
    required this.teamB,
    required this.battingTeam,
    required this.bowlingTeam,
    this.isFirstInnings = true,
  });

  @override
  State<ScoreBoardPage> createState() => _ScoreBoardPageState();
}

class _ScoreBoardPageState extends State<ScoreBoardPage> {
  List<String> thisOverRuns = ["W", "1", "2", "0"];
  late String title;

  List<BatsmanStats> batsmen = [
    BatsmanStats(
      name: "Shikhar Dhawan*",
      runs: 72,
      balls: 39,
      fours: 10,
      sixes: 2,
      strikeRate: 300.00,
    ),
    BatsmanStats(
      name: "Virat Kohli",
      runs: 26,
      balls: 20,
      fours: 2,
      sixes: 1,
      strikeRate: 100.00,
    ),
  ];

  List<BowlerStats> bowlers = [
    BowlerStats(
      name: "Bhuvneshwar Kumar",
      overs: 4,
      maidens: 0,
      runs: 24,
      wickets: 5,
      economy: 18.00,
    ),
  ];

  @override
  void initState() {
    title = '${widget.teamA} vs ${widget.teamB}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003366),
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Text(
            //   widget.battingTeam,
            //   style: const TextStyle(fontSize: 20, color: Colors.white),
            //   textAlign: TextAlign.center,
            // ),
            // const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "102/2",
                  style: TextStyle(fontSize: 50, color: Colors.white),
                ),
                SizedBox(width: 20),
                Text(
                  "10.2 Ov",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                infoChip("Target: 200"),
                const SizedBox(width: 10),
                infoChip("CRR: 10.0"),
              ],
            ),
            const SizedBox(height: 12),
            thisOverWidget(thisOverRuns),
            ScoreSummaryCard(batsmen: batsmen, bowlers: bowlers),
          ],
        ),
      ),
    );
  }

  Widget infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(129, 112, 167, 212),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget thisOverWidget(List<String> runs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("This over ", style: TextStyle(color: Colors.white)),
        const Text("|", style: TextStyle(fontSize: 20, color: Colors.white)),
        const SizedBox(width: 5),
        SizedBox(
          width: 200,
          height: 40,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: runs.map((run) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    width: 25,
                    height: 25,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      run,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          "| 3",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
