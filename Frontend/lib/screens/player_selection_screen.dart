import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';
import '../core/theme/app_theme.dart';

class PlayerSelectionScreen extends StatefulWidget {
  const PlayerSelectionScreen({super.key});

  @override
  State<PlayerSelectionScreen> createState() => _PlayerSelectionScreenState();
}

class _PlayerSelectionScreenState extends State<PlayerSelectionScreen> {
  final _strikerController = TextEditingController();
  final _nonStrikerController = TextEditingController();
  final _bowlerController = TextEditingController();

  final List<String> _recentPlayers = [];

  @override
  void dispose() {
    _strikerController.dispose();
    _nonStrikerController.dispose();
    _bowlerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matchProvider = context.watch<MatchProvider>();
    final match = matchProvider.currentMatch;

    if (match == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Player Selection')),
        body: const Center(child: Text('No active match')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Players'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '${match.battingTeam} Batting',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${match.bowlingTeam} Bowling',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildPlayerField(
              'Striker',
              _strikerController,
              Icons.sports_cricket,
            ),
            const SizedBox(height: 16),
            _buildPlayerField(
              'Non-Striker',
              _nonStrikerController,
              Icons.person,
            ),
            const SizedBox(height: 16),
            _buildPlayerField(
              'Bowler',
              _bowlerController,
              Icons.sports_baseball,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _startInnings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.successColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Start Innings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            if (_recentPlayers.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Recent Players',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _recentPlayers.map((player) {
                  return ActionChip(
                    label: Text(player),
                    onPressed: () => _selectRecentPlayer(player),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.accentColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.accentColor, width: 2),
        ),
      ),
      textCapitalization: TextCapitalization.words,
    );
  }

  void _selectRecentPlayer(String player) {
    // Logic to auto-fill player name
    if (_strikerController.text.isEmpty) {
      _strikerController.text = player;
    } else if (_nonStrikerController.text.isEmpty) {
      _nonStrikerController.text = player;
    } else if (_bowlerController.text.isEmpty) {
      _bowlerController.text = player;
    }
  }

  void _startInnings() {
    if (_strikerController.text.isEmpty ||
        _nonStrikerController.text.isEmpty ||
        _bowlerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all player names'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (_strikerController.text == _nonStrikerController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Striker and Non-Striker must be different'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    context.read<MatchProvider>().addPlayers(
      striker: _strikerController.text.trim(),
      nonStriker: _nonStrikerController.text.trim(),
      bowler: _bowlerController.text.trim(),
    );

    Navigator.pushReplacementNamed(context, '/scoreboard');
  }
}
