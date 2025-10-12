import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/match_models.dart';

class MatchProvider extends ChangeNotifier {
  Match? _currentMatch;
  Innings? _currentInnings;
  int _strikerIndex = 0;
  int _nonStrikerIndex = 1;
  int _currentBowlerIndex = 0;
  final List<Ball> _currentOverBalls = [];

  // Getters
  Match? get currentMatch => _currentMatch;
  Innings? get currentInnings => _currentInnings;
  int get strikerIndex => _strikerIndex;
  int get nonStrikerIndex => _nonStrikerIndex;
  int get currentBowlerIndex => _currentBowlerIndex;
  List<Ball> get currentOverBalls => _currentOverBalls;

  // Match statistics
  int get totalRuns => _currentInnings?.totalRuns ?? 0;
  int get wickets => _currentInnings?.wickets ?? 0;
  int get overs => _currentInnings?.overs ?? 0;
  int get balls => _currentInnings?.balls ?? 0;
  double get currentRunRate => _currentInnings?.currentRunRate ?? 0.0;
  int get remainingBalls => 6 - balls;

  // Target and required run rate (for second innings)
  int get target {
    if (_currentMatch == null || _currentMatch!.isFirstInnings) return 0;
    return _currentMatch!.innings.first.totalRuns + 1;
  }

  double get requiredRunRate {
    if (_currentMatch == null || _currentMatch!.isFirstInnings) return 0.0;
    int runsNeeded = target - totalRuns;
    int ballsRemaining = (_currentMatch!.totalOvers * 6) - (overs * 6 + balls);
    return ballsRemaining > 0 ? (runsNeeded * 6.0) / ballsRemaining : 0.0;
  }

  // Initialize new match
  void initializeMatch(Match match) {
    _currentMatch = match;
    _startNewInnings();
    _saveMatchData();
    notifyListeners();
  }

  // Start new innings
  void _startNewInnings() {
    if (_currentMatch == null) return;

    final innings = Innings(
      battingTeam: _currentMatch!.battingTeam,
      bowlingTeam: _currentMatch!.bowlingTeam,
      inningsNumber: _currentMatch!.innings.length + 1,
    );

    _currentMatch!.innings.add(innings);
    _currentInnings = innings;
    _strikerIndex = 0;
    _nonStrikerIndex = 1;
    _currentBowlerIndex = 0;
    _currentOverBalls.clear();
  }

  // Add players to current innings
  void addPlayers({
    required String striker,
    required String nonStriker,
    required String bowler,
  }) {
    if (_currentInnings == null) return;

    // Add batsmen
    _currentInnings!.batsmen.addAll([
      BatsmanStats(name: striker, isOnStrike: true),
      BatsmanStats(name: nonStriker),
    ]);

    // Add bowler
    _currentInnings!.bowlers.add(
      BowlerStats(name: bowler, isCurrentBowler: true),
    );

    _saveMatchData();
    notifyListeners();
  }

  // Add new batsman (when wicket falls)
  void addNewBatsman(String name) {
    if (_currentInnings == null) return;

    // Replace the out batsman
    final newBatsman = BatsmanStats(
      name: name,
      isOnStrike: _strikerIndex < _currentInnings!.batsmen.length
          ? _currentInnings!.batsmen[_strikerIndex].isOnStrike
          : false,
    );

    if (_strikerIndex < _currentInnings!.batsmen.length) {
      _currentInnings!.batsmen[_strikerIndex] = newBatsman;
    } else {
      _currentInnings!.batsmen.add(newBatsman);
    }

    _saveMatchData();
    notifyListeners();
  }

  // Add new bowler (when over ends)
  void addNewBowler(String name) {
    if (_currentInnings == null) return;

    // Mark current bowler as not current
    if (_currentBowlerIndex < _currentInnings!.bowlers.length) {
      _currentInnings!.bowlers[_currentBowlerIndex].isCurrentBowler = false;
    }

    // Check if bowler already exists
    int existingBowlerIndex = _currentInnings!.bowlers.indexWhere(
      (b) => b.name == name && !b.isCurrentBowler,
    );

    if (existingBowlerIndex != -1) {
      _currentBowlerIndex = existingBowlerIndex;
      _currentInnings!.bowlers[existingBowlerIndex].isCurrentBowler = true;
    } else {
      _currentInnings!.bowlers.add(
        BowlerStats(name: name, isCurrentBowler: true),
      );
      _currentBowlerIndex = _currentInnings!.bowlers.length - 1;
    }

    _saveMatchData();
    notifyListeners();
  }

  // Record a ball
  void recordBall({
    required int runs,
    bool isWide = false,
    bool isNoBall = false,
    bool isBye = false,
    bool isLegBye = false,
    bool isWicket = false,
    String? wicketType,
    String? fielderName,
  }) {
    if (_currentInnings == null || _currentMatch == null) return;

    // Create ball object
    String display = runs.toString();
    if (isWide) display += 'wd';
    if (isNoBall) display += 'nb';
    if (isBye) display += 'b';
    if (isLegBye) display += 'lb';
    if (isWicket) display = 'W';

    final ball = Ball(
      runs: runs,
      isWide: isWide,
      isNoBall: isNoBall,
      isBye: isBye,
      isLegBye: isLegBye,
      isWicket: isWicket,
      wicketType: wicketType,
      batsmanName: _currentInnings!.batsmen[_strikerIndex].name,
      display: display,
    );

    _currentOverBalls.add(ball);

    // Update innings totals
    _currentInnings!.totalRuns += runs;
    if (ball.isExtra) _currentInnings!.extras += runs;

    // Update batsman stats (only if not byes/leg byes)
    if (!isBye &&
        !isLegBye &&
        _strikerIndex < _currentInnings!.batsmen.length) {
      final batsman = _currentInnings!.batsmen[_strikerIndex];
      if (ball.isLegalDelivery) {
        batsman.updateStats(runs);
      } else if (!isWide) {
        // No ball - batsman gets runs but ball doesn't count
        batsman.runs += runs;
        if (runs == 4) batsman.fours++;
        if (runs == 6) batsman.sixes++;
        batsman.strikeRate = batsman.balls > 0
            ? (batsman.runs / batsman.balls) * 100
            : 0.0;
      }
    }

    // Update bowler stats
    if (_currentBowlerIndex < _currentInnings!.bowlers.length) {
      final bowler = _currentInnings!.bowlers[_currentBowlerIndex];
      if (ball.isLegalDelivery) {
        bowler.updateStats(runs, isWicket);
        _currentInnings!.balls++;
        if (_currentInnings!.balls == 6) {
          _currentInnings!.overs++;
          _currentInnings!.balls = 0;
          _completeOver();
        }
      } else {
        // Wide or no ball - runs added but no ball progression
        bowler.runs += runs;
        if (isWicket) bowler.wickets++;
        double totalOvers = bowler.overs + (bowler.balls / 6.0);
        bowler.economy = totalOvers > 0 ? bowler.runs / totalOvers : 0.0;
      }
    }

    // Handle wicket
    if (isWicket) {
      _handleWicket(wicketType, fielderName);
    }

    // Change strike if odd runs and legal delivery
    if (runs % 2 == 1 && ball.isLegalDelivery) {
      _swapStrike();
    }

    // Update current run rate
    double totalOvers = _currentInnings!.overs + (_currentInnings!.balls / 6.0);
    _currentInnings!.currentRunRate = totalOvers > 0
        ? _currentInnings!.totalRuns / totalOvers
        : 0.0;

    // Check if innings/match is complete
    _checkInningsComplete();

    _saveMatchData();
    notifyListeners();
  }

  // Handle wicket
  void _handleWicket(String? wicketType, String? fielderName) {
    if (_currentInnings == null) return;

    _currentInnings!.wickets++;

    // Mark batsman as out
    if (_strikerIndex < _currentInnings!.batsmen.length) {
      final batsman = _currentInnings!.batsmen[_strikerIndex];
      batsman.isOut = true;
      batsman.dismissalType = wicketType;
      batsman.fielderName = fielderName;
      if (_currentBowlerIndex < _currentInnings!.bowlers.length) {
        batsman.bowlerName = _currentInnings!.bowlers[_currentBowlerIndex].name;
      }
    }

    // Add to fall of wickets
    _currentInnings!.fallOfWickets.add(
      Wicket(
        batsmanName: _currentInnings!.batsmen[_strikerIndex].name,
        dismissalType: wicketType ?? 'Unknown',
        bowlerName: _currentBowlerIndex < _currentInnings!.bowlers.length
            ? _currentInnings!.bowlers[_currentBowlerIndex].name
            : null,
        fielderName: fielderName,
        runs: _currentInnings!.totalRuns,
        wickets: _currentInnings!.wickets,
        overs: _currentInnings!.overs + (_currentInnings!.balls / 6.0),
      ),
    );
  }

  // Complete over
  void _completeOver() {
    if (_currentInnings == null) return;

    // Create over record
    final over = Over(
      overNumber: _currentInnings!.overs,
      bowlerName: _currentBowlerIndex < _currentInnings!.bowlers.length
          ? _currentInnings!.bowlers[_currentBowlerIndex].name
          : 'Unknown',
      balls: List.from(_currentOverBalls),
    );

    // Calculate over stats
    over.runs = _currentOverBalls.fold(0, (sum, ball) => sum + ball.runs);
    over.wickets = _currentOverBalls.where((ball) => ball.isWicket).length;

    _currentInnings!.oversData.add(over);
    _currentOverBalls.clear();

    // Swap strike at end of over
    _swapStrike();
  }

  // Swap strike between batsmen
  void swapStrike() {
    _swapStrike();
    notifyListeners();
  }

  void _swapStrike() {
    if (_currentInnings == null) return;

    // Update strike status
    if (_strikerIndex < _currentInnings!.batsmen.length) {
      _currentInnings!.batsmen[_strikerIndex].isOnStrike = false;
    }
    if (_nonStrikerIndex < _currentInnings!.batsmen.length) {
      _currentInnings!.batsmen[_nonStrikerIndex].isOnStrike = true;
    }

    // Swap indices
    int temp = _strikerIndex;
    _strikerIndex = _nonStrikerIndex;
    _nonStrikerIndex = temp;
  }

  // Retire batsman
  void retireBatsman(String newBatsmanName) {
    if (_currentInnings == null) return;

    // Mark current batsman as retired
    if (_strikerIndex < _currentInnings!.batsmen.length) {
      _currentInnings!.batsmen[_strikerIndex].dismissalType = 'Retired';
      _currentInnings!.batsmen[_strikerIndex].isOut = true;
    }

    // Add new batsman
    addNewBatsman(newBatsmanName);
  }

  // Check if innings is complete
  void _checkInningsComplete() {
    if (_currentMatch == null || _currentInnings == null) return;

    bool inningsComplete = false;

    // Check if all overs bowled
    if (_currentInnings!.overs >= _currentMatch!.totalOvers) {
      inningsComplete = true;
    }

    // Check if all wickets fallen
    if (_currentInnings!.wickets >= _currentMatch!.playersPerTeam - 1) {
      inningsComplete = true;
    }

    // Check if target achieved (second innings)
    if (!_currentMatch!.isFirstInnings &&
        _currentInnings!.totalRuns >= target) {
      inningsComplete = true;
      _currentMatch!.status = 'completed';
      _currentMatch!.result =
          '${_currentMatch!.battingTeam} won by ${_currentMatch!.playersPerTeam - _currentInnings!.wickets} wickets';
    }

    if (inningsComplete) {
      if (_currentMatch!.isFirstInnings) {
        // Start second innings
        _currentMatch!.isFirstInnings = false;
        String temp = _currentMatch!.battingTeam;
        _currentMatch!.battingTeam = _currentMatch!.bowlingTeam;
        _currentMatch!.bowlingTeam = temp;
        _startNewInnings();
      } else {
        // Match complete
        _currentMatch!.status = 'completed';
        if (_currentMatch!.result == null) {
          int margin =
              _currentMatch!.innings.first.totalRuns -
              _currentInnings!.totalRuns;
          _currentMatch!.result =
              '${_currentMatch!.bowlingTeam} won by $margin runs';
        }
      }
    }
  }

  // Undo last ball (simplified version)
  void undoLastBall() {
    if (_currentOverBalls.isNotEmpty) {
      _currentOverBalls.removeLast();
      // Note: This is a simplified undo. A complete implementation would
      // need to reverse all the stat updates, which is complex.
      notifyListeners();
    }
  }

  // Save match data to local storage
  Future<void> _saveMatchData() async {
    if (_currentMatch == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final matchJson = jsonEncode(_currentMatch!.toJson());
      await prefs.setString('current_match', matchJson);
    } catch (e) {
      debugPrint('Error saving match data: $e');
    }
  }

  // Load match data from local storage
  Future<void> loadMatchData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final matchJson = prefs.getString('current_match');

      if (matchJson != null) {
        final matchData = jsonDecode(matchJson);
        _currentMatch = Match.fromJson(matchData);

        if (_currentMatch!.innings.isNotEmpty) {
          _currentInnings = _currentMatch!.innings.last;

          // Restore current indices
          for (int i = 0; i < _currentInnings!.batsmen.length; i++) {
            if (_currentInnings!.batsmen[i].isOnStrike) {
              _strikerIndex = i;
            }
          }

          for (int i = 0; i < _currentInnings!.bowlers.length; i++) {
            if (_currentInnings!.bowlers[i].isCurrentBowler) {
              _currentBowlerIndex = i;
            }
          }
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading match data: $e');
    }
  }

  // Clear current match
  void clearMatch() {
    _currentMatch = null;
    _currentInnings = null;
    _strikerIndex = 0;
    _nonStrikerIndex = 1;
    _currentBowlerIndex = 0;
    _currentOverBalls.clear();

    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('current_match');
    });

    notifyListeners();
  }
}
