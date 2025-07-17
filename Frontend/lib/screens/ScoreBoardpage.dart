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
  List<String> thisOverRuns = [
    "W",
    "1",
    "2",
    "0",
    "4",
    "1",
    "W",
    "6",
    "0",
    "1",
  ];
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

  int strikerBatmansIndex = 0;

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
                infoChip("Target: -"),
                const SizedBox(width: 10),
                infoChip("CRR: 10.0"),
              ],
            ),
            const SizedBox(height: 12),
            thisOverWidget(thisOverRuns),
            ScoreSummaryCard(batsmen: batsmen, bowlers: bowlers),

            // Primary Button Row
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                customButton("Retire", () {}),
                customButton("Swap Striker", () {}),
                customButton("End Over", () {}),
                customButton(
                  "Undo",
                  () {},
                  color: const Color.fromARGB(255, 250, 98, 131),
                  textColor: Colors.white,
                ),
              ],
            ),

            const SizedBox(height: 16),
            EventRadioButtonGroup(
              onChanged: (selectedExtras, selectedWicket) {
                debugPrint(
                  "Extras: $selectedExtras, Wicket Event: $selectedWicket",
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget customButton(
    String label,
    VoidCallback onPressed, {
    Color color = Colors.white,
    Color textColor = Colors.black,
  }) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(70, 40),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: const TextStyle(fontSize: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(label, style: TextStyle(color: textColor)),
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
        const Text("| ", style: TextStyle(color: Colors.white, fontSize: 20)),
        const Text("3", style: TextStyle(color: Colors.white)),
      ],
    );
  }
}

class EventRadioButtonGroup extends StatefulWidget {
  final void Function(String?, String?) onChanged;

  const EventRadioButtonGroup({super.key, required this.onChanged});

  @override
  State<EventRadioButtonGroup> createState() => _EventRadioButtonGroupState();
}

class _EventRadioButtonGroupState extends State<EventRadioButtonGroup> {
  String? selectedExtras;
  String? selectedWicket;
  final List<String> extras = ['Wide', 'No ball', 'Byes', 'Leg byes'];
  final List<String> wicketEvents = ['Wicket', 'Run out'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: extras.map((event) {
            return ChoiceChip(
              label: Text(event),
              selected: selectedExtras == event,
              onSelected: (_) {
                setState(() {
                  if (selectedWicket == event) {
                    selectedWicket = null;
                  } else {
                    selectedWicket = event;
                  }
                  widget.onChanged(selectedExtras, selectedWicket);
                });
              },
              selectedColor: Colors.green,
              labelStyle: TextStyle(
                color: selectedExtras == event ? Colors.white : Colors.black,
                fontSize: 13,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: const BorderSide(color: Colors.grey),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: wicketEvents.map((event) {
            return ChoiceChip(
              label: Text(event),
              selected: selectedWicket == event,
              onSelected: (_) {
                setState(() {
                  if (selectedWicket == event) {
                    selectedWicket = null;
                  } else {
                    selectedWicket = event;
                  }
                  widget.onChanged(selectedExtras, selectedWicket);
                });
              },
              selectedColor: Colors.red,
              labelStyle: TextStyle(
                color: selectedWicket == event ? Colors.white : Colors.black,
                fontSize: 13,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: const BorderSide(color: Colors.grey),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}


// ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   final current = batsmen[strikerBatmansIndex];

//                   final updatedRuns = current.runs + 1;
//                   final updatedBalls = current.balls + 1;
//                   final updatedStrikeRate = updatedBalls > 0
//                       ? (updatedRuns / updatedBalls) * 100
//                       : 0.0;

//                   batsmen[strikerBatmansIndex] = BatsmanStats(
//                     name: current.name,
//                     runs: updatedRuns,
//                     balls: updatedBalls,
//                     fours: current.fours,
//                     sixes: current.sixes,
//                     strikeRate: updatedStrikeRate,
//                   );
//                 });
//               },

//               child: const Text("Add run for batsman"),
//             ),