import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

enum TossDecision { bat, bowl }

class _MainPageState extends State<MainPage> {
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
      appBar: AppBar(title: const Text("Match Setup")),
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
                    String teamA = teamAController.text;
                    String teamB = teamBController.text;
                    String overs = oversController.text;
                    String playersCount = playersCountController.text;

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
