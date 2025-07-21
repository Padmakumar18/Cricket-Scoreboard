import 'package:flutter/material.dart';
import 'package:Frontend/screens/ScoreBoardpage.dart';

class GetMatchDetails extends StatefulWidget {
  const GetMatchDetails({super.key});

  @override
  State<GetMatchDetails> createState() => _GetMatchDetailsState();
}

enum TossDecision { bat, bowl }

class _GetMatchDetailsState extends State<GetMatchDetails> {
  final _formKey = GlobalKey<FormState>();

  late String teamA;
  late String teamB;
  late String overs;
  late String playersCount;
  late String battingTeam;
  late String bowlingTeam;

  late TextEditingController teamAController;
  late TextEditingController teamBController;
  late TextEditingController oversController;
  late TextEditingController playersCountController;

  String? tossWonBy;
  TossDecision? chooseTo;
  bool isSubmitted = false;

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

  void _startMatch() {
    setState(() {
      isSubmitted = true;
    });

    if (_formKey.currentState!.validate() && chooseTo != null) {
      teamA = teamAController.text.trim();
      teamB = teamBController.text.trim();
      overs = oversController.text.trim();
      playersCount = playersCountController.text.trim();

      if (chooseTo == TossDecision.bat) {
        battingTeam = tossWonBy == teamA ? teamA : teamB;
        bowlingTeam = tossWonBy == teamA ? teamB : teamA;
      } else {
        bowlingTeam = tossWonBy == teamA ? teamA : teamB;
        battingTeam = tossWonBy == teamA ? teamB : teamA;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScoreBoardPage(
            teamA: teamA,
            teamB: teamB,
            battingTeam: battingTeam,
            bowlingTeam: bowlingTeam,
          ),
        ),
      );
    }
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: teamAController,
                      decoration: const InputDecoration(labelText: 'Team A'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter Team A';
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: teamBController,
                      decoration: const InputDecoration(labelText: 'Team B'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter Team B';
                        } else if (value.trim() ==
                            teamAController.text.trim()) {
                          return 'Team B must be different from Team A';
                        }
                        return null;
                      },
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
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter overs';
                  }
                  final num = int.tryParse(value.trim());
                  if (num == null || num <= 0) {
                    return 'Enter a valid number of overs';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: playersCountController,
                decoration: const InputDecoration(labelText: 'Players Count'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter number of players';
                  }
                  final num = int.tryParse(value.trim());
                  if (num == null || num <= 0) {
                    return 'Enter a valid count';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: tossWonBy,
                decoration: const InputDecoration(labelText: 'Toss Won By'),
                items: teamOptions.map((team) {
                  return DropdownMenuItem<String>(
                    value: team,
                    child: Text(team),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    tossWonBy = value;
                  });
                },
                validator: (value) =>
                    value == null || value.isEmpty ? 'Select a team' : null,
              ),
              const SizedBox(height: 16),

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
              if (isSubmitted && chooseTo == null)
                const Padding(
                  padding: EdgeInsets.only(left: 12.0, top: 4),
                  child: Text(
                    'Select toss decision',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isSubmitted = true;
                      });
                      if (_formKey.currentState!.validate() &&
                          chooseTo != null) {
                        _startMatch();
                      }
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
                        isSubmitted = false;
                      });
                    },
                    child: const Text('Clear Fields'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
