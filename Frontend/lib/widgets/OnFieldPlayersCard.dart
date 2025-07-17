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
            widget.onSubmit(_bowlerController.text);
            Navigator.of(context).pop();
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
