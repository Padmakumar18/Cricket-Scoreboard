import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/services/statistics_service.dart';
import 'package:frontend/models/match_models.dart';

void main() {
  late StatisticsService statisticsService;

  setUp(() {
    statisticsService = StatisticsService();
  });

  group('StatisticsService Tests', () {
    test('Calculate team statistics correctly', () {
      final matches = [
        _createCompletedMatch(
          'Team A',
          'Team B',
          result: 'Team A won by 5 wickets',
        ),
        _createCompletedMatch(
          'Team A',
          'Team C',
          result: 'Team C won by 20 runs',
        ),
      ];

      final stats = statisticsService.calculateTeamStatistics(
        matches,
        'Team A',
      );

      expect(stats.teamName, 'Team A');
      expect(stats.matchesPlayed, 2);
      expect(stats.matchesWon, 1);
      expect(stats.matchesLost, 1);
      expect(stats.winPercentage, 50.0);
    });

    test('Calculate player batting statistics', () {
      final matches = [
        _createMatchWithPlayerStats(
          playerName: 'Player 1',
          runs: 50,
          balls: 30,
          fours: 5,
          sixes: 2,
        ),
        _createMatchWithPlayerStats(
          playerName: 'Player 1',
          runs: 75,
          balls: 45,
          fours: 8,
          sixes: 3,
        ),
      ];

      final stats = statisticsService.calculatePlayerStatistics(
        matches,
        'Player 1',
      );

      expect(stats.playerName, 'Player 1');
      expect(stats.matchesPlayed, 2);
      expect(stats.totalRuns, 125);
      expect(stats.totalBalls, 75);
      expect(stats.fours, 13);
      expect(stats.sixes, 5);
    });

    test('Get top batsmen sorted by runs', () {
      final matches = [
        _createMatchWithPlayerStats(
          playerName: 'Player 1',
          runs: 100,
          balls: 60,
        ),
        _createMatchWithPlayerStats(
          playerName: 'Player 2',
          runs: 75,
          balls: 50,
        ),
        _createMatchWithPlayerStats(
          playerName: 'Player 3',
          runs: 150,
          balls: 80,
        ),
      ];

      final topBatsmen = statisticsService.getTopBatsmen(matches, limit: 3);

      expect(topBatsmen.length, 3);
      expect(topBatsmen[0].playerName, 'Player 3');
      expect(topBatsmen[0].totalRuns, 150);
      expect(topBatsmen[1].playerName, 'Player 1');
      expect(topBatsmen[2].playerName, 'Player 2');
    });

    test('Get top bowlers sorted by wickets', () {
      final matches = [
        _createMatchWithBowlerStats(
          bowlerName: 'Bowler 1',
          wickets: 3,
          runs: 25,
        ),
        _createMatchWithBowlerStats(
          bowlerName: 'Bowler 2',
          wickets: 5,
          runs: 30,
        ),
        _createMatchWithBowlerStats(
          bowlerName: 'Bowler 3',
          wickets: 2,
          runs: 20,
        ),
      ];

      final topBowlers = statisticsService.getTopBowlers(matches, limit: 3);

      expect(topBowlers.length, 3);
      expect(topBowlers[0].playerName, 'Bowler 2');
      expect(topBowlers[0].wickets, 5);
      expect(topBowlers[1].playerName, 'Bowler 1');
      expect(topBowlers[2].playerName, 'Bowler 3');
    });

    test('Handle empty match list', () {
      final stats = statisticsService.calculateTeamStatistics([], 'Team A');

      expect(stats.matchesPlayed, 0);
      expect(stats.matchesWon, 0);
      expect(stats.matchesLost, 0);
      expect(stats.winPercentage, 0.0);
    });

    test('Calculate strike rate correctly', () {
      final matches = [
        _createMatchWithPlayerStats(
          playerName: 'Player 1',
          runs: 50,
          balls: 25,
        ),
      ];

      final stats = statisticsService.calculatePlayerStatistics(
        matches,
        'Player 1',
      );

      expect(stats.strikeRate, 200.0);
    });

    test('Calculate bowling economy correctly', () {
      final matches = [
        _createMatchWithBowlerStats(
          bowlerName: 'Bowler 1',
          wickets: 2,
          runs: 24,
          overs: 4,
        ),
      ];

      final stats = statisticsService.calculatePlayerStatistics(
        matches,
        'Bowler 1',
      );

      expect(stats.economy, 6.0);
    });
  });
}

Match _createCompletedMatch(String teamA, String teamB, {String? result}) {
  final match = Match(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    teamA: teamA,
    teamB: teamB,
    totalOvers: 20,
    playersPerTeam: 11,
    tossWinner: teamA,
    tossWinnerChoseToBat: true,
    startTime: DateTime.now(),
    battingTeam: teamA,
    bowlingTeam: teamB,
    status: 'completed',
    result: result,
  );

  final innings = Innings(
    battingTeam: teamA,
    bowlingTeam: teamB,
    inningsNumber: 1,
    totalRuns: 150,
    wickets: 5,
    overs: 20,
  );

  match.innings.add(innings);
  return match;
}

Match _createMatchWithPlayerStats({
  required String playerName,
  required int runs,
  required int balls,
  int fours = 0,
  int sixes = 0,
}) {
  final match = Match(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
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

  final innings = Innings(
    battingTeam: 'Team A',
    bowlingTeam: 'Team B',
    inningsNumber: 1,
  );

  innings.batsmen.add(
    BatsmanStats(
      name: playerName,
      runs: runs,
      balls: balls,
      fours: fours,
      sixes: sixes,
      strikeRate: balls > 0 ? (runs / balls) * 100 : 0,
    ),
  );

  match.innings.add(innings);
  return match;
}

Match _createMatchWithBowlerStats({
  required String bowlerName,
  required int wickets,
  required int runs,
  int overs = 4,
}) {
  final match = Match(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
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

  final innings = Innings(
    battingTeam: 'Team A',
    bowlingTeam: 'Team B',
    inningsNumber: 1,
  );

  innings.bowlers.add(
    BowlerStats(
      name: bowlerName,
      overs: overs,
      runs: runs,
      wickets: wickets,
      economy: runs / overs,
    ),
  );

  match.innings.add(innings);
  return match;
}
