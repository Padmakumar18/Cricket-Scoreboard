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
    "wd",
    "lb2",
    "wk",
    "1",
    "nb5",
    "wd-ro-1",
    "W",
    "6",
    "0",
    "4",
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
                const SizedBox(width: 10),
                infoChip("Req RR: 10.0"),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "34 runs needed in 36 overs",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            // const SizedBox(height: 12),
            thisOverWidget(thisOverRuns),
            ScoreSummaryCard(batsmen: batsmen, bowlers: bowlers),

            // Primary Button Row
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                customButton("Retire", () {}),
                customButton("Swap striker", () {}),
                customButton("End over", () {}),
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

            const SizedBox(height: 16),
            Column(
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ...['0', '1', '2', '3', '4', '5', '6'].map((run) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 4 - 20,
                        child: ElevatedButton(
                          onPressed: () {
                            debugPrint("Run selected: $run");
                            // TODO: Add run logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            run,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    }).toList(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4 - 20,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              final controller = TextEditingController();
                              return AlertDialog(
                                title: const Text("Enter More Runs"),
                                content: TextField(
                                  controller: controller,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: "Enter runs > 6",
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (controller.text.isNotEmpty) {
                                        debugPrint(
                                          "More run: ${controller.text}",
                                        );
                                        // TODO: Handle more run logic
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "More",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(70, 40),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: const TextStyle(fontSize: 15),
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
        const Text("<", style: TextStyle(fontSize: 20, color: Colors.white)),
        const SizedBox(width: 5),
        SizedBox(
          width: 220,
          height: 60,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: runs.map((run) {
                final isLong = run.length > 3;
                bool isNumeric = RegExp(r'^\d+$').hasMatch(run);
                Color bgColor = Colors.white;
                if (run == "4" || run == "6") {
                  bgColor = Colors.green;
                } else if (isNumeric && run != "0") {
                  bgColor = const Color.fromARGB(255, 255, 166, 0);
                }

                bool isDotBall = run == "0";

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: 35,
                      maxWidth: isLong ? 70 : 40,
                      minHeight: 35,
                      maxHeight: isLong ? 50 : 40,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: isDotBall
                        ? const Icon(Icons.park, size: 16, color: Colors.black)
                        : FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              run,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 5),
        const Text("> ", style: TextStyle(color: Colors.white, fontSize: 20)),
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
                  if (selectedExtras == event) {
                    selectedExtras = null;
                  } else {
                    selectedExtras = event;
                  }
                  widget.onChanged(selectedExtras, selectedWicket);
                });
              },
              selectedColor: Colors.green,
              labelStyle: TextStyle(
                color: selectedExtras == event ? Colors.white : Colors.black,
                fontSize: 15,
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
                fontSize: 15,
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