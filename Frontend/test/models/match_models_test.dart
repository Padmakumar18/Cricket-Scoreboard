import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/match_models.dart';

void main() {
  group('Match Model Tests', () {
    test('Match creation with required fields', () {
      final match = Match(
        id: '1',
        teamA: 'Team A',
        teamB: 'Team B',
        totalOvers: 20,
        playersPerTeam: 11,
        tossWinner: 'Team A',
        tossWinnerChoseToBat: true,
        startTime: DateTime.now(),
        battingTeam: 'Team A',
        bowlingTeam: 'Team B',
      );

      expect(match.id, '1');
      expect(match.teamA, 'Team A');
      expect(match.teamB, 'Team B');
      expect(match.totalOvers, 20);
      expect(match.isFirstInnings, true);
      expect(match.status, 'ongoing');
    });

    test('Match JSON serialization and deserialization', () {
      final match = Match(
        id: '1',
        teamA: 'Team A',
        teamB: 'Team B',
        totalOvers: 20,
        playersPerTeam: 11,
        tossWinner: 'Team A',
        tossWinnerChoseToBat: true,
        startTime: DateTime(2024, 1, 1),
        battingTeam: 'Team A',
        bowlingTeam: 'Team B',
      );

      final json = match.toJson();
      final deserializedMatch = Match.fromJson(json);

      expect(deserializedMatch.id, match.id);
      expect(deserializedMatch.teamA, match.teamA);
      expect(deserializedMatch.teamB, match.teamB);
      expect(deserializedMatch.totalOvers, match.totalOvers);
    });
  });

  group('Innings Model Tests', () {
    test('Innings creation with default values', () {
      final innings = Innings(
        battingTeam: 'Team A',
        bowlingTeam: 'Team B',
        inningsNumber: 1,
      );

      expect(innings.totalRuns, 0);
      expect(innings.wickets, 0);
      expect(innings.overs, 0);
      expect(innings.balls, 0);
      expect(innings.extras, 0);
      expect(innings.currentRunRate, 0.0);
    });

    test('Innings JSON serialization', () {
      final innings = Innings(
        battingTeam: 'Team A',
        bowlingTeam: 'Team B',
        inningsNumber: 1,
        totalRuns: 150,
        wickets: 5,
        overs: 18,
        balls: 3,
      );

      final json = innings.toJson();
      final deserialized = Innings.fromJson(json);

      expect(deserialized.totalRuns, 150);
      expect(deserialized.wickets, 5);
      expect(deserialized.overs, 18);
      expect(deserialized.balls, 3);
    });
  });

  group('BatsmanStats Tests', () {
    test('Batsman stats update correctly', () {
      final batsman = BatsmanStats(name: 'Player 1');

      batsman.updateStats(4);
      expect(batsman.runs, 4);
      expect(batsman.balls, 1);
      expect(batsman.fours, 1);
      expect(batsman.strikeRate, 400.0);

      batsman.updateStats(6);
      expect(batsman.runs, 10);
      expect(batsman.balls, 2);
      expect(batsman.sixes, 1);
      expect(batsman.strikeRate, 500.0);
    });

    test('Batsman strike rate calculation', () {
      final batsman = BatsmanStats(name: 'Player 1');

      batsman.updateStats(1);
      batsman.updateStats(2);
      batsman.updateStats(3);

      expect(batsman.runs, 6);
      expect(batsman.balls, 3);
      expect(batsman.strikeRate, 200.0);
    });

    test('Batsman JSON serialization', () {
      final batsman = BatsmanStats(
        name: 'Player 1',
        runs: 50,
        balls: 30,
        fours: 5,
        sixes: 2,
        strikeRate: 166.67,
      );

      final json = batsman.toJson();
      final deserialized = BatsmanStats.fromJson(json);

      expect(deserialized.name, 'Player 1');
      expect(deserialized.runs, 50);
      expect(deserialized.balls, 30);
      expect(deserialized.fours, 5);
      expect(deserialized.sixes, 2);
    });
  });

  group('BowlerStats Tests', () {
    test('Bowler stats update correctly', () {
      final bowler = BowlerStats(name: 'Bowler 1');

      bowler.updateStats(0, true);
      expect(bowler.wickets, 1);
      expect(bowler.balls, 1);
      expect(bowler.runs, 0);

      bowler.updateStats(4, false);
      expect(bowler.balls, 2);
      expect(bowler.runs, 4);
    });

    test('Bowler over completion', () {
      final bowler = BowlerStats(name: 'Bowler 1');

      for (int i = 0; i < 6; i++) {
        bowler.updateStats(1, false);
      }

      expect(bowler.overs, 1);
      expect(bowler.balls, 0);
      expect(bowler.runs, 6);
    });

    test('Bowler economy calculation', () {
      final bowler = BowlerStats(name: 'Bowler 1');

      for (int i = 0; i < 6; i++) {
        bowler.updateStats(2, false);
      }

      expect(bowler.overs, 1);
      expect(bowler.runs, 12);
      expect(bowler.economy, 12.0);
    });

    test('Bowler JSON serialization', () {
      final bowler = BowlerStats(
        name: 'Bowler 1',
        overs: 4,
        balls: 0,
        runs: 25,
        wickets: 2,
        economy: 6.25,
      );

      final json = bowler.toJson();
      final deserialized = BowlerStats.fromJson(json);

      expect(deserialized.name, 'Bowler 1');
      expect(deserialized.overs, 4);
      expect(deserialized.runs, 25);
      expect(deserialized.wickets, 2);
    });
  });

  group('Ball Model Tests', () {
    test('Ball creation with extras', () {
      final wideBall = Ball(runs: 1, isWide: true, display: '1wd');

      expect(wideBall.isExtra, true);
      expect(wideBall.isLegalDelivery, false);

      final normalBall = Ball(runs: 4, display: '4');

      expect(normalBall.isExtra, false);
      expect(normalBall.isLegalDelivery, true);
    });

    test('Ball JSON serialization', () {
      final ball = Ball(
        runs: 6,
        isWicket: true,
        wicketType: 'Bowled',
        batsmanName: 'Player 1',
        display: 'W',
      );

      final json = ball.toJson();
      final deserialized = Ball.fromJson(json);

      expect(deserialized.runs, 6);
      expect(deserialized.isWicket, true);
      expect(deserialized.wicketType, 'Bowled');
      expect(deserialized.batsmanName, 'Player 1');
    });
  });

  group('Over Model Tests', () {
    test('Over creation and ball tracking', () {
      final over = Over(overNumber: 1, bowlerName: 'Bowler 1');

      over.balls.add(Ball(runs: 1, display: '1'));
      over.balls.add(Ball(runs: 4, display: '4'));
      over.balls.add(Ball(runs: 0, isWicket: true, display: 'W'));

      expect(over.balls.length, 3);
      expect(over.overNumber, 1);
    });

    test('Over JSON serialization', () {
      final over = Over(
        overNumber: 1,
        bowlerName: 'Bowler 1',
        runs: 8,
        wickets: 1,
      );

      final json = over.toJson();
      final deserialized = Over.fromJson(json);

      expect(deserialized.overNumber, 1);
      expect(deserialized.bowlerName, 'Bowler 1');
      expect(deserialized.runs, 8);
      expect(deserialized.wickets, 1);
    });
  });

  group('Wicket Model Tests', () {
    test('Wicket creation', () {
      final wicket = Wicket(
        batsmanName: 'Player 1',
        dismissalType: 'Caught',
        bowlerName: 'Bowler 1',
        fielderName: 'Fielder 1',
        runs: 50,
        wickets: 1,
        overs: 10.3,
      );

      expect(wicket.batsmanName, 'Player 1');
      expect(wicket.dismissalType, 'Caught');
      expect(wicket.bowlerName, 'Bowler 1');
      expect(wicket.fielderName, 'Fielder 1');
    });

    test('Wicket JSON serialization', () {
      final wicket = Wicket(
        batsmanName: 'Player 1',
        dismissalType: 'LBW',
        bowlerName: 'Bowler 1',
        runs: 75,
        wickets: 3,
        overs: 15.2,
      );

      final json = wicket.toJson();
      final deserialized = Wicket.fromJson(json);

      expect(deserialized.batsmanName, 'Player 1');
      expect(deserialized.dismissalType, 'LBW');
      expect(deserialized.runs, 75);
      expect(deserialized.wickets, 3);
    });
  });
}
