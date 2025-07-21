import 'package:flutter/material.dart';

class PlayerEntryDialog extends StatefulWidget {
  final Function(String striker, String nonStriker, String bowler) onSubmit;

  const PlayerEntryDialog({super.key, required this.onSubmit});

  @override
  _PlayerEntryDialogState createState() => _PlayerEntryDialogState();
}

class _PlayerEntryDialogState extends State<PlayerEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _strikerController = TextEditingController();
  final _nonStrikerController = TextEditingController();
  final _bowlerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Enter Players"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _strikerController,
              decoration: const InputDecoration(labelText: "Striker Name"),
              validator: (value) => value == null || value.trim().isEmpty
                  ? "Striker name is required"
                  : null,
            ),
            TextFormField(
              controller: _nonStrikerController,
              decoration: const InputDecoration(labelText: "Non-Striker Name"),
              validator: (value) => value == null || value.trim().isEmpty
                  ? "Non-striker name is required"
                  : null,
            ),
            TextFormField(
              controller: _bowlerController,
              decoration: const InputDecoration(labelText: "Bowler Name"),
              validator: (value) => value == null || value.trim().isEmpty
                  ? "Bowler name is required"
                  : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(
                _strikerController.text,
                _nonStrikerController.text,
                _bowlerController.text,
              );
              Navigator.of(context, rootNavigator: true).pop();
            }
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
  final _formKey = GlobalKey<FormState>();
  final _batterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New Batter"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _batterController,
          decoration: const InputDecoration(labelText: "Enter Batter Name"),
          validator: (value) =>
              value == null || value.trim().isEmpty ? "Required" : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(_batterController.text);
              Navigator.of(context).pop();
            }
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
  final _formKey = GlobalKey<FormState>();
  final _bowlerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New Bowler"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _bowlerController,
          decoration: const InputDecoration(labelText: "Enter Bowler Name"),
          validator: (value) =>
              value == null || value.trim().isEmpty ? "Required" : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(_bowlerController.text);
              Navigator.of(context).pop();
            }
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
