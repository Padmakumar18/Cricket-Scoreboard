import 'package:Frontend/screens/ScoreBoardpage.dart';
import 'package:flutter/material.dart';

class GetMatchDetails extends StatefulWidget {
  const GetMatchDetails({super.key});

  @override
  State<GetMatchDetails> createState() => _GetMatchDetailsState();
}

enum TossDecision { bat, bowl }

class _GetMatchDetailsState extends State<GetMatchDetails> {
  late String teamA;
  late String teamB;
  late String overs;
  late String playersCount;

  // Is this required?
  late String battingTeam;
  late String bowlingTeam;

  late TextEditingController teamAController;
  late TextEditingController teamBController;
  late TextEditingController oversController;
  late TextEditingController playersCountController;

  String? tossWonBy;
  TossDecision? chooseTo;

  @override
  void initState() {
    super.initState();
    teamAController = TextEditingController();
    teamBController = TextEditingController();
    oversController = TextEditingController();
    playersCountController = TextEditingController();
  }

  @override
  void dispose() {
    teamAController.dispose();
    teamBController.dispose();
    oversController.dispose();
    playersCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> teamOptions = [
      teamAController.text.isEmpty ? 'Team A' : teamAController.text,
      teamBController.text.isEmpty ? 'Team B' : teamBController.text,
    ];

    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 0, 50, 90),
      appBar: AppBar(
        title: const Text("Match Setup"),
        // backgroundColor: const Color.fromARGB(255, 0, 50, 90),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: teamAController,
                    decoration: const InputDecoration(labelText: 'Team A'),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: teamBController,
                    decoration: const InputDecoration(labelText: 'Team B'),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: oversController,
              decoration: const InputDecoration(labelText: 'Overs'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: tossWonBy,
              decoration: const InputDecoration(labelText: 'Toss Won By'),
              items: teamOptions.map((team) {
                return DropdownMenuItem<String>(value: team, child: Text(team));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  tossWonBy = value;
                });
              },
            ),

            const SizedBox(height: 16),
            TextFormField(
              controller: playersCountController,
              decoration: const InputDecoration(labelText: 'Players Count'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            /// Choose To
            const Text("Choose To:"),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<TossDecision>(
                    title: const Text('Bat'),
                    value: TossDecision.bat,
                    groupValue: chooseTo,
                    onChanged: (TossDecision? value) {
                      setState(() {
                        chooseTo = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<TossDecision>(
                    title: const Text('Bowl'),
                    value: TossDecision.bowl,
                    groupValue: chooseTo,
                    onChanged: (TossDecision? value) {
                      setState(() {
                        chooseTo = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    teamA = teamAController.text;
                    teamB = teamBController.text;
                    overs = oversController.text;
                    playersCount = playersCountController.text;

                    // bowlingTeam =
                    //     tossWonBy == teamA && chooseTo == TossDecision.bat
                    //     ? teamBController.text
                    //     : teamAController.text;
                    // battingTeam = bowlingTeam == teamA ? teamB : teamA;

                    switch (chooseTo) {
                      case TossDecision.bat:
                        battingTeam = tossWonBy == teamA ? teamA : teamB;
                        bowlingTeam = tossWonBy == teamA ? teamB : teamA;
                        break;
                      case TossDecision.bowl:
                        bowlingTeam = tossWonBy == teamA ? teamA : teamB;
                        battingTeam = tossWonBy == teamA ? teamB : teamA;
                        break;
                      default:
                        battingTeam = 'Team A';
                        bowlingTeam = 'Team B';
                    }
                    print('Team A: $teamA');
                    print('Team B: $teamB');
                    print('Overs: $overs');
                    print('Players Count: $playersCount');
                    print('Toss Won By: $tossWonBy');
                    print(
                      'Choose To: ${chooseTo == TossDecision.bat ? 'Bat' : 'Bowl'}',
                    );

                    // Clear the fields
                    teamAController.clear();
                    teamBController.clear();
                    oversController.clear();
                    playersCountController.clear();
                    setState(() {
                      tossWonBy = null;
                      chooseTo = null;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScoreBoardPage(
                          teamA: teamAController.text,
                          teamB: teamBController.text,
                          battingTeam: battingTeam,
                          bowlingTeam: bowlingTeam,
                        ),
                      ),
                    );
                  },
                  child: const Text('Start Match'),
                ),
                ElevatedButton(
                  onPressed: () {
                    teamAController.clear();
                    teamBController.clear();
                    oversController.clear();
                    playersCountController.clear();
                    setState(() {
                      tossWonBy = null;
                      chooseTo = null;
                    });
                  },
                  child: const Text('Clear Fields'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
