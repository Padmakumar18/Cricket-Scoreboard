import 'package:flutter/material.dart';
import 'package:Frontend/widgets/ScoreSummaryCard.dart';
import 'package:Frontend/widgets/OnFieldPlayersCard.dart';

class ScoreBoardPage extends StatefulWidget {
  final String battingTeam;
  final String bowlingTeam;
  final int totalOvers;
  final int playersCount;

  const ScoreBoardPage({
    super.key,
    required this.battingTeam,
    required this.bowlingTeam,
    required this.totalOvers,
    required this.playersCount,
  });

  @override
  State<ScoreBoardPage> createState() => _ScoreBoardPageState();
}

class _ScoreBoardPageState extends State<ScoreBoardPage> {
  late String title; // for title

  bool isFirstInnings = true;

  int matchOvers = 0; // for count completed overs
  int remainingBalls = 6; // over remaining balls
  int thisOverRunsCount = 0; // currrent over run

  int totalRuns = 0;
  int wickets = 0;

  int target = 0;
  double currentRunRate = 0.0;

  int strikerBatmansIndex = 0;
  int bowlerIndex = 0;
  bool isWicketFallen = false;

  List<String> thisOverRuns = [];
  List<BatsmanStats> batsmen = [];
  List<BowlerStats> bowlers = [];

  @override
  void initState() {
    super.initState();
    title = '${widget.battingTeam} vs ${widget.bowlingTeam}';

    // showPlayerEntryDialog(); // for get strikder and nn striker , bowler detais
    bowlerIndex = 0;
    batsmen = [
      BatsmanStats(
        name: "striker",
        runs: 0,
        balls: 0,
        fours: 0,
        sixes: 0,
        strikeRate: 0.0,
      ),
      BatsmanStats(
        name: "nonStriker",
        runs: 0,
        balls: 0,
        fours: 0,
        sixes: 0,
        strikeRate: 0.0,
      ),
    ];

    bowlers = [
      BowlerStats(
        name: "bowler",
        overs: 0,
        maidens: 0,
        runs: 0,
        totalBalls: 0,
        wickets: 0,
        economy: 0.0,
      ),
    ];
  }

  void showPlayerEntryDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PlayerEntryDialog(
          onSubmit: (striker, nonStriker, bowler) {
            debugPrint(
              "Striker: $striker, Non-Striker: $nonStriker, Bowler: $bowler",
            );
            setState(() {
              if (batsmen.length < 2) {
                batsmen = [
                  BatsmanStats(
                    name: striker,
                    runs: 0,
                    balls: 0,
                    fours: 0,
                    sixes: 0,
                    strikeRate: 0.0,
                  ),
                  BatsmanStats(
                    name: nonStriker,
                    runs: 0,
                    balls: 0,
                    fours: 0,
                    sixes: 0,
                    strikeRate: 0.0,
                  ),
                ];
              } else {
                batsmen[0].name = "$striker*";
                batsmen[1].name = nonStriker;
              }

              if (bowlers.isEmpty) {
                bowlers = [
                  BowlerStats(
                    name: bowler,
                    overs: 0,
                    maidens: 0,
                    totalBalls: 0,
                    runs: 0,
                    wickets: 0,
                    economy: 0.0,
                  ),
                ];
                bowlerIndex = 0;
              } else {
                bowlers[0].name = bowler;
              }
            });
          },
        ),
      );
    });
  }

  void _updatedBatsmanStats(int run) {
    final currentBatsman = batsmen[strikerBatmansIndex];

    /// If leg byes or byes are selected, we don't update batsman runs
    currentBatsman.runs += run;

    currentBatsman.balls += 1;
    currentBatsman.strikeRate = currentBatsman.balls > 0
        ? (currentBatsman.runs / currentBatsman.balls) * 100
        : 0.0;

    if (run == 4) {
      currentBatsman.fours += 1;
    } else if (run == 6) {
      currentBatsman.sixes++;
    }
  }

  void _updatedBowlerStats(int run) {
    final currentBowler = bowlers[bowlerIndex];

    currentBowler.runs += run;
    currentBowler.totalBalls += 1;
    currentBowler.economy = double.parse(
      (currentBowler.runs / currentBowler.totalBalls).toStringAsFixed(2),
    );

    if (remainingBalls == 0 && thisOverRunsCount == 0) {
      currentBowler.maidens += 1;
    }

    if (isWicketFallen) {
      currentBowler.wickets += 1;
    }
  }

  void _updateScoreCard(String strRun) {
    thisOverRuns.add(strRun);
    thisOverRunsCount += int.parse(strRun);
    totalRuns += int.parse(strRun);

    // update batmans stats
    _updatedBatsmanStats(int.parse(strRun));

    // updated bowler stats
    _updatedBowlerStats(int.parse(strRun));

    currentRunRate = totalRuns == 0
        ? 0
        : totalRuns / ((matchOvers * 6) + (6 - remainingBalls));
    remainingBalls--;
    matchOvers = remainingBalls == 0 ? matchOvers + 1 : matchOvers;

    if (matchOvers == widget.totalOvers && remainingBalls == 0) {
      isFirstInnings = !isFirstInnings;
      if (isFirstInnings) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/GetMatchDetails',
          (Route<dynamic> route) => false,
        );
        return;
      }
      target = totalRuns + 1;

      _resetScoreCard();

      showPlayerEntryDialog();

      return;
    }
    if (remainingBalls == 0) {
      remainingBalls = 6;
      thisOverRunsCount = 0;
      thisOverRuns.clear();
      strikerBatmansIndex = int.parse(strRun) % 2 != 0
          ? strikerBatmansIndex
          : strikerBatmansIndex == 0
          ? 1
          : 0;
      return;
    }
    strikerBatmansIndex = int.parse(strRun) % 2 == 0
        ? strikerBatmansIndex
        : strikerBatmansIndex == 0
        ? 1
        : 0;
  }

  void _addNewBatter(String batterName) {
    batsmen[strikerBatmansIndex] = BatsmanStats(
      name: batterName,
      runs: 0,
      balls: 0,
      fours: 0,
      sixes: 0,
      strikeRate: 0.0,
    );
  }

  void _resetScoreCard() {
    setState(() {
      matchOvers = 0;
      remainingBalls = 6;
      thisOverRunsCount = 0;
      totalRuns = 0;
      wickets = 0;
      currentRunRate = 0.0;
      thisOverRuns.clear();
      batsmen.clear();
      bowlers.clear();
      strikerBatmansIndex = 0;
    });
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
              children: [
                Text(
                  "$totalRuns/$wickets",
                  style: TextStyle(fontSize: 50, color: Colors.white),
                ),
                SizedBox(width: 20),
                Text(
                  '$matchOvers.${6 - remainingBalls} / ${widget.totalOvers} Ov',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                infoChip("Target : ${isFirstInnings ? "-" : target}"),
                const SizedBox(width: 10),
                infoChip("CRR : ${currentRunRate.toStringAsFixed(2)}"),
                // const SizedBox(width: 10), write this in future
                // infoChip("Req RR: 10.0"),
                const SizedBox(width: 10),
                infoChip('Players count : ${widget.playersCount}'),
              ],
            ),
            if (!isFirstInnings && target > totalRuns) ...[
              const SizedBox(height: 12),
              Text(
                "${target - totalRuns} runs needed in ${(widget.totalOvers * 6) - ((matchOvers * 6) + (6 - remainingBalls))} balls",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],

            thisOverWidget(thisOverRuns),
            ScoreSummaryCard(
              batsmen: batsmen,
              bowlers: bowlers,
              strikerIndex: strikerBatmansIndex,
            ),

            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                customButton("Retire", () {
                  showDialog(
                    context: context,
                    builder: (_) => NewBatterDialog(
                      onSubmit: (batterName) {
                        debugPrint("New Batter after Retire: $batterName");
                        _addNewBatter(batterName);
                      },
                    ),
                  );
                }),
                customButton("Swap striker", () {
                  setState(() {
                    strikerBatmansIndex = strikerBatmansIndex == 0 ? 1 : 0;
                  });
                }),
                customButton("End over", () {
                  showDialog(
                    context: context,
                    builder: (_) => NewBowlerDialog(
                      onSubmit: (batterName) {
                        debugPrint("New Bowler after End Over: $batterName");
                        // TODO: Add new batter to batsmen list or update index
                      },
                    ),
                  );
                }),
                customButton(
                  "Undo",
                  () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm Undo"),
                          content: const Text(
                            "Are you sure you want to undo the last action?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                debugPrint("Undo confirmed.");
                              },
                              child: const Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  color: const Color.fromARGB(255, 250, 98, 131),
                  textColor: Colors.white,
                ),
              ],
            ),

            // const SizedBox(height: 16),
            EventRadioButtonGroup(
              onChanged: (selectedExtras, selectedWicket) {
                debugPrint(
                  "Extras: $selectedExtras, Wicket Event: $selectedWicket",
                );
                setState(() {
                  isWicketFallen =
                      selectedWicket == "Wicket" || selectedWicket == "Run Out";
                });
              },
            ),
            const Divider(color: Colors.white70),

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

                            setState(() {
                              _updateScoreCard(run);
                            });
                            if (isWicketFallen) {
                              Future.delayed(
                                const Duration(milliseconds: 300),
                                () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => NewBatterDialog(
                                      onSubmit: (batterName) {
                                        debugPrint(
                                          "New Batter after run $run: $batterName",
                                        );
                                      },
                                    ),
                                  ).then((_) {
                                    setState(() {
                                      isWicketFallen = false;
                                    });
                                  });
                                },
                              );
                            }
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
                    // "More" button
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

                                        if (isWicketFallen) {
                                          Future.delayed(
                                            const Duration(milliseconds: 300),
                                            () {
                                              showDialog(
                                                context: context,
                                                builder: (_) => NewBatterDialog(
                                                  onSubmit: (batterName) {
                                                    debugPrint(
                                                      "New Batter after more run: $batterName",
                                                    );
                                                  },
                                                ),
                                              ).then((_) {
                                                setState(() {
                                                  isWicketFallen = false;
                                                });
                                              });
                                            },
                                          );
                                        }
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
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          // minimumSize: const Size(70, 40),
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
        Text("$thisOverRunsCount", style: TextStyle(color: Colors.white)),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Wrap(
            spacing: 10,
            runSpacing: 8,
            children: extras.map((event) {
              return ChoiceChip(
                label: Text(event),
                selected: selectedExtras == event,
                onSelected: (_) {
                  setState(() {
                    selectedExtras = selectedExtras == event ? null : event;
                    widget.onChanged(selectedExtras, selectedWicket);
                  });
                },
                selectedColor: Colors.green,
                labelStyle: TextStyle(
                  color: selectedExtras == event ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: const BorderSide(color: Colors.grey),
                ),
              );
            }).toList(),
          ),
        ),
        // const SizedBox(height: 8),
        Align(
          alignment: Alignment.center,
          child: Wrap(
            spacing: 10,
            runSpacing: 8,
            children: wicketEvents.map((event) {
              return ChoiceChip(
                label: Text(event),
                selected: selectedWicket == event,
                onSelected: (_) {
                  setState(() {
                    selectedWicket = selectedWicket == event ? null : event;
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
        ),
      ],
    );
  }
}


//// ---------------- This is for update batsman runs and balls -------------------

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



/// ------------------- This is for testing purposes only -------------------
                    // showDialog(
                    //   context: context,
                    //   barrierDismissible: true, // allow tapping outside
                    //   builder: (context) => MatchResultDialog(
                    //     winningTeam: "Challengers",
                    //     losingTeam: "Warriors",
                    //     onStartNewMatch: () {
                    //       Navigator.pushNamedAndRemoveUntil(
                    //         context,
                    //         '/start',
                    //         (route) => false,
                    //       );
                    //     },
                    //     onViewScorecard: () {
                    //       Navigator.pushNamed(context, '/scorecard');
                    //     },
                    //   ),
                    // ).then((_) {
                    //   // If dialog is closed without using the buttons
                    //   Navigator.pushNamedAndRemoveUntil(
                    //     context,
                    //     '/home',
                    //     (route) => false,
                    //   );
                    // });