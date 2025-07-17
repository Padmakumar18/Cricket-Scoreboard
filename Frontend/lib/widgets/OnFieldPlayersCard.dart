import 'package:flutter/material.dart';

class PlayerEntryDialog extends StatefulWidget {
  final Function(String striker, String nonStriker, String bowler) onSubmit;

  const PlayerEntryDialog({super.key, required this.onSubmit});

  @override
  _PlayerEntryDialogState createState() => _PlayerEntryDialogState();
}

class _PlayerEntryDialogState extends State<PlayerEntryDialog> {
  final _strikerController = TextEditingController();
  final _nonStrikerController = TextEditingController();
  final _bowlerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Enter Players"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _strikerController,
            decoration: const InputDecoration(labelText: "Striker Name"),
          ),
          TextField(
            controller: _nonStrikerController,
            decoration: const InputDecoration(labelText: "Non-Striker Name"),
          ),
          TextField(
            controller: _bowlerController,
            decoration: const InputDecoration(labelText: "Bowler Name"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            widget.onSubmit(
              _strikerController.text,
              _nonStrikerController.text,
              _bowlerController.text,
            );
            Navigator.of(context).pop();
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}

class NewBatterDialog extends StatefulWidget {
  final Function(String batterName) onSubmit;

  const NewBatterDialog({super.key, required this.onSubmit});

  @override
  _NewBatterDialogState createState() => _NewBatterDialogState();
}

class _NewBatterDialogState extends State<NewBatterDialog> {
  final _batterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New Batter"),
      content: TextField(
        controller: _batterController,
        decoration: const InputDecoration(labelText: "Enter Batter Name"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            widget.onSubmit(_batterController.text);
            Navigator.of(context).pop();
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}

class NewBowlerDialog extends StatefulWidget {
  final Function(String bowlerName) onSubmit;

  const NewBowlerDialog({super.key, required this.onSubmit});

  @override
  _NewBowlerDialogState createState() => _NewBowlerDialogState();
}

class _NewBowlerDialogState extends State<NewBowlerDialog> {
  final _bowlerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New Bowler"),
      content: TextField(
        controller: _bowlerController,
        decoration: const InputDecoration(labelText: "Enter Bowler Name"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            widget.onSubmit(_bowlerController.text);
            Navigator.of(context).pop();
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}

class MatchResultDialog extends StatelessWidget {
  final String winningTeam;
  final String losingTeam;
  final VoidCallback onStartNewMatch;
  final VoidCallback onViewScorecard;

  const MatchResultDialog({
    super.key,
    required this.winningTeam,
    required this.losingTeam,
    required this.onStartNewMatch,
    required this.onViewScorecard,
  });

  void _goToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _goToHome(context);
        return false;
      },
      child: Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "🏁 Match Result",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "$winningTeam won the match!",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Better luck next time, $losingTeam.",
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: onViewScorecard,
                        icon: const Icon(Icons.insert_chart),
                        label: const Text("View Scorecard"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: onStartNewMatch,
                        icon: const Icon(Icons.replay),
                        label: const Text("Start New Match"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => _goToHome(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
