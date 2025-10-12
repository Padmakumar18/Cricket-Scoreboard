import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/match_provider.dart';
import '../models/match_models.dart';
import '../widgets/responsive_layout.dart';
import '../core/theme/app_theme.dart';

class MatchSetupScreen extends StatefulWidget {
  const MatchSetupScreen({super.key});

  @override
  State<MatchSetupScreen> createState() => _MatchSetupScreenState();
}

class _MatchSetupScreenState extends State<MatchSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamAController = TextEditingController();
  final _teamBController = TextEditingController();
  final _oversController = TextEditingController(text: '20');
  final _playersController = TextEditingController(text: '11');

  String? _tossWinner;
  bool _tossWinnerChoseToBat = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _teamAController.dispose();
    _teamBController.dispose();
    _oversController.dispose();
    _playersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Setup'),
        backgroundColor: AppTheme.backgroundColor,
      ),
      body: ResponsiveBuilder(
        builder: (context, constraints, deviceType) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppTheme.backgroundColor, AppTheme.surfaceColor],
              ),
            ),
            child: SafeArea(
              child: ResponsiveContainer(
                maxWidth: deviceType == DeviceType.mobile
                    ? double.infinity
                    : 600,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(deviceType),
                        const SizedBox(height: 32),
                        _buildTeamSection(deviceType),
                        const SizedBox(height: 24),
                        _buildMatchDetailsSection(deviceType),
                        const SizedBox(height: 24),
                        _buildTossSection(deviceType),
                        const SizedBox(height: 32),
                        _buildActionButtons(context, deviceType),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(DeviceType deviceType) {
    return Column(
      children: [
        Icon(
          Icons.sports_cricket,
          size: deviceType == DeviceType.mobile ? 48 : 64,
          color: AppTheme.accentColor,
        ).animate().scale(duration: 600.ms),
        const SizedBox(height: 16),
        Text(
          'Setup New Match',
          style: TextStyle(
            fontSize: deviceType == DeviceType.mobile ? 24 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 8),
        Text(
          'Configure your cricket match settings',
          style: TextStyle(
            fontSize: deviceType == DeviceType.mobile ? 14 : 16,
            color: Colors.white70,
          ),
        ).animate().fadeIn(delay: 500.ms),
      ],
    );
  }

  Widget _buildTeamSection(DeviceType deviceType) {
    return ResponsiveCard(
      color: AppTheme.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Teams',
            style: TextStyle(
              fontSize: deviceType == DeviceType.mobile ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ResponsiveLayout(
            mobile: Column(
              children: [
                _buildTeamField('Team A', _teamAController, Icons.group),
                const SizedBox(height: 16),
                _buildTeamField(
                  'Team B',
                  _teamBController,
                  Icons.group_outlined,
                ),
              ],
            ),
            tablet: Row(
              children: [
                Expanded(
                  child: _buildTeamField(
                    'Team A',
                    _teamAController,
                    Icons.group,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTeamField(
                    'Team B',
                    _teamBController,
                    Icons.group_outlined,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3);
  }

  Widget _buildTeamField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: AppTheme.accentColor),
        filled: true,
        fillColor: AppTheme.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.accentColor, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label name';
        }
        if (label == 'Team B' && value.trim() == _teamAController.text.trim()) {
          return 'Team names must be different';
        }
        return null;
      },
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _buildMatchDetailsSection(DeviceType deviceType) {
    return ResponsiveCard(
      color: AppTheme.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Match Details',
            style: TextStyle(
              fontSize: deviceType == DeviceType.mobile ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ResponsiveLayout(
            mobile: Column(
              children: [
                _buildNumberField(
                  'Overs',
                  _oversController,
                  Icons.timer,
                  1,
                  50,
                ),
                const SizedBox(height: 16),
                _buildNumberField(
                  'Players per Team',
                  _playersController,
                  Icons.people,
                  6,
                  15,
                ),
              ],
            ),
            tablet: Row(
              children: [
                Expanded(
                  child: _buildNumberField(
                    'Overs',
                    _oversController,
                    Icons.timer,
                    1,
                    50,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildNumberField(
                    'Players per Team',
                    _playersController,
                    Icons.people,
                    6,
                    15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.3);
  }

  Widget _buildNumberField(
    String label,
    TextEditingController controller,
    IconData icon,
    int min,
    int max,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: AppTheme.accentColor),
        filled: true,
        fillColor: AppTheme.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.accentColor, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }
        final num = int.tryParse(value.trim());
        if (num == null || num < min || num > max) {
          return '$label must be between $min and $max';
        }
        return null;
      },
    );
  }

  Widget _buildTossSection(DeviceType deviceType) {
    final teamOptions = [
      _teamAController.text.isEmpty ? 'Team A' : _teamAController.text,
      _teamBController.text.isEmpty ? 'Team B' : _teamBController.text,
    ];

    return ResponsiveCard(
      color: AppTheme.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Toss Details',
            style: TextStyle(
              fontSize: deviceType == DeviceType.mobile ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _tossWinner,
            style: const TextStyle(color: Colors.white),
            dropdownColor: AppTheme.surfaceColor,
            decoration: InputDecoration(
              labelText: 'Toss Won By',
              labelStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.casino, color: AppTheme.accentColor),
              filled: true,
              fillColor: AppTheme.surfaceColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.accentColor,
                  width: 2,
                ),
              ),
            ),
            items: teamOptions.map((team) {
              return DropdownMenuItem<String>(
                value: team,
                child: Text(team, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (value) => setState(() => _tossWinner = value),
            validator: (value) =>
                value == null ? 'Please select toss winner' : null,
          ),
          const SizedBox(height: 16),
          Text(
            'Toss Winner Chose To:',
            style: TextStyle(
              fontSize: deviceType == DeviceType.mobile ? 16 : 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          ResponsiveLayout(
            mobile: Column(
              children: [
                _buildTossChoice('Bat First', true, Icons.sports_cricket),
                _buildTossChoice('Bowl First', false, Icons.sports_baseball),
              ],
            ),
            tablet: Row(
              children: [
                Expanded(
                  child: _buildTossChoice(
                    'Bat First',
                    true,
                    Icons.sports_cricket,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTossChoice(
                    'Bowl First',
                    false,
                    Icons.sports_baseball,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.3);
  }

  Widget _buildTossChoice(String label, bool value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => _tossWinnerChoseToBat = value),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _tossWinnerChoseToBat == value
                ? AppTheme.accentColor.withValues(alpha: 0.2)
                : AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _tossWinnerChoseToBat == value
                  ? AppTheme.accentColor
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: _tossWinnerChoseToBat == value
                    ? AppTheme.accentColor
                    : Colors.white70,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: _tossWinnerChoseToBat == value
                      ? AppTheme.accentColor
                      : Colors.white70,
                  fontWeight: _tossWinnerChoseToBat == value
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              const Spacer(),
              if (_tossWinnerChoseToBat == value)
                const Icon(Icons.check_circle, color: AppTheme.accentColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, DeviceType deviceType) {
    return ResponsiveLayout(
      mobile: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStartButton(context, deviceType),
          const SizedBox(height: 12),
          _buildClearButton(deviceType),
        ],
      ),
      tablet: Row(
        children: [
          Expanded(child: _buildClearButton(deviceType)),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: _buildStartButton(context, deviceType)),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, DeviceType deviceType) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : () => _startMatch(context),
      icon: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.play_arrow),
      label: Text(_isLoading ? 'Starting...' : 'Start Match'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.successColor,
        padding: EdgeInsets.symmetric(
          vertical: deviceType == DeviceType.mobile ? 16 : 20,
        ),
        textStyle: TextStyle(
          fontSize: deviceType == DeviceType.mobile ? 16 : 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ).animate().scale(delay: 600.ms);
  }

  Widget _buildClearButton(DeviceType deviceType) {
    return OutlinedButton.icon(
      onPressed: _isLoading ? null : _clearForm,
      icon: const Icon(Icons.clear),
      label: const Text('Clear'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white70,
        side: const BorderSide(color: Colors.white70),
        padding: EdgeInsets.symmetric(
          vertical: deviceType == DeviceType.mobile ? 16 : 20,
        ),
        textStyle: TextStyle(
          fontSize: deviceType == DeviceType.mobile ? 16 : 18,
        ),
      ),
    ).animate().scale(delay: 700.ms);
  }

  void _startMatch(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final match = Match(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        teamA: _teamAController.text.trim(),
        teamB: _teamBController.text.trim(),
        totalOvers: int.parse(_oversController.text.trim()),
        playersPerTeam: int.parse(_playersController.text.trim()),
        tossWinner: _tossWinner!,
        tossWinnerChoseToBat: _tossWinnerChoseToBat,
        startTime: DateTime.now(),
        battingTeam: _tossWinnerChoseToBat
            ? _tossWinner!
            : (_tossWinner == _teamAController.text.trim()
                  ? _teamBController.text.trim()
                  : _teamAController.text.trim()),
        bowlingTeam: _tossWinnerChoseToBat
            ? (_tossWinner == _teamAController.text.trim()
                  ? _teamBController.text.trim()
                  : _teamAController.text.trim())
            : _tossWinner!,
      );

      context.read<MatchProvider>().initializeMatch(match);

      // Small delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/scoreboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting match: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearForm() {
    _teamAController.clear();
    _teamBController.clear();
    _oversController.text = '20';
    _playersController.text = '11';
    setState(() {
      _tossWinner = null;
      _tossWinnerChoseToBat = true;
    });
  }
}
