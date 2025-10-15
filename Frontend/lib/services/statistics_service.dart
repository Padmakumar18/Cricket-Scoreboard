import '../models/match_models.dart';
import '../models/statistics_models.dart';

class StatisticsService {
  TeamStatistics calculateTeamStatistics(List<Match> matches, String teamName) {
    int played = 0;
    int won = 0;
    int lost = 0;
    int totalRuns = 0;
    int totalWickets = 0;

    for (var match in matches) {
      if (match.teamA == teamName || match.teamB == teamName) {
        played++;

        if (match.status == 'completed' && match.result != null) {
          if (match.result!.contains(teamName) &&
              match.result!.contains('won')) {
            won++;
          } else {
            lost++;
          }
        }

        // Calculate runs and wickets
        for (var innings in match.innings) {
          if (innings.battingTeam == teamName) {
            totalRuns += innings.totalRuns;
          }
          if (innings.bowlingTeam == teamName) {
            totalWickets += innings.wickets;
          }
        }
      }
    }

    return TeamStatistics(
      teamName: teamName,
      matchesPlayed: played,
      matchesWon: won,
      matchesLost: lost,
      totalRuns: totalRuns,
      totalWickets: totalWickets,
      averageScore: played > 0 ? totalRuns / played : 0,
      winPercentage: played > 0 ? (won / played) * 100 : 0,
    );
  }

  PlayerStatistics calculatePlayerStatistics(
    List<Match> matches,
    String playerName,
  ) {
    int matchesPlayed = 0;
    int totalRuns = 0;
    int totalBalls = 0;
    int fours = 0;
    int sixes = 0;
    int wickets = 0;
    int ballsBowled = 0;
    int runsConceded = 0;
    int highestScore = 0;
    int bestBowling = 0;

    for (var match in matches) {
      bool played = false;

      for (var innings in match.innings) {
        // Batting stats
        for (var batsman in innings.batsmen) {
          if (batsman.name == playerName) {
            played = true;
            totalRuns += batsman.runs;
            totalBalls += batsman.balls;
            fours += batsman.fours;
            sixes += batsman.sixes;
            if (batsman.runs > highestScore) {
              highestScore = batsman.runs;
            }
          }
        }

        // Bowling stats
        for (var bowler in innings.bowlers) {
          if (bowler.name == playerName) {
            played = true;
            wickets += bowler.wickets;
            ballsBowled += (bowler.overs * 6) + bowler.balls;
            runsConceded += bowler.runs;
            if (bowler.wickets > bestBowling) {
              bestBowling = bowler.wickets;
            }
          }
        }
      }

      if (played) matchesPlayed++;
    }

    return PlayerStatistics(
      playerName: playerName,
      matchesPlayed: matchesPlayed,
      totalRuns: totalRuns,
      totalBalls: totalBalls,
      fours: fours,
      sixes: sixes,
      battingAverage: totalBalls > 0 ? totalRuns / (totalBalls / 100) : 0,
      strikeRate: totalBalls > 0 ? (totalRuns / totalBalls) * 100 : 0,
      highestScore: highestScore,
      wickets: wickets,
      ballsBowled: ballsBowled,
      runsConceded: runsConceded,
      bowlingAverage: wickets > 0 ? runsConceded / wickets : 0,
      economy: ballsBowled > 0 ? (runsConceded / (ballsBowled / 6)) : 0,
      bestBowling: bestBowling,
    );
  }

  List<PlayerStatistics> getTopBatsmen(List<Match> matches, {int limit = 10}) {
    final Map<String, PlayerStatistics> playerStats = {};

    for (var match in matches) {
      for (var innings in match.innings) {
        for (var batsman in innings.batsmen) {
          if (!playerStats.containsKey(batsman.name)) {
            playerStats[batsman.name] = calculatePlayerStatistics(
              matches,
              batsman.name,
            );
          }
        }
      }
    }

    final sortedPlayers = playerStats.values.toList()
      ..sort((a, b) => b.totalRuns.compareTo(a.totalRuns));

    return sortedPlayers.take(limit).toList();
  }

  List<PlayerStatistics> getTopBowlers(List<Match> matches, {int limit = 10}) {
    final Map<String, PlayerStatistics> playerStats = {};

    for (var match in matches) {
      for (var innings in match.innings) {
        for (var bowler in innings.bowlers) {
          if (!playerStats.containsKey(bowler.name)) {
            playerStats[bowler.name] = calculatePlayerStatistics(
              matches,
              bowler.name,
            );
          }
        }
      }
    }

    final sortedPlayers = playerStats.values.toList()
      ..sort((a, b) => b.wickets.compareTo(a.wickets));

    return sortedPlayers.take(limit).toList();
  }
}
