class TeamStatistics {
  final String teamName;
  final int matchesPlayed;
  final int matchesWon;
  final int matchesLost;
  final int totalRuns;
  final int totalWickets;
  final double averageScore;
  final double winPercentage;

  TeamStatistics({
    required this.teamName,
    required this.matchesPlayed,
    required this.matchesWon,
    required this.matchesLost,
    required this.totalRuns,
    required this.totalWickets,
    required this.averageScore,
    required this.winPercentage,
  });

  int get matchesDraw => matchesPlayed - matchesWon - matchesLost;
}

class PlayerStatistics {
  final String playerName;
  final int matchesPlayed;
  final int totalRuns;
  final int totalBalls;
  final int fours;
  final int sixes;
  final double battingAverage;
  final double strikeRate;
  final int highestScore;
  final int wickets;
  final int ballsBowled;
  final int runsConceded;
  final double bowlingAverage;
  final double economy;
  final int bestBowling;

  PlayerStatistics({
    required this.playerName,
    required this.matchesPlayed,
    required this.totalRuns,
    required this.totalBalls,
    required this.fours,
    required this.sixes,
    required this.battingAverage,
    required this.strikeRate,
    required this.highestScore,
    required this.wickets,
    required this.ballsBowled,
    required this.runsConceded,
    required this.bowlingAverage,
    required this.economy,
    required this.bestBowling,
  });
}

class MatchSummary {
  final String matchId;
  final String teamA;
  final String teamB;
  final String result;
  final DateTime date;
  final int totalRuns;
  final int totalWickets;
  final String? manOfTheMatch;

  MatchSummary({
    required this.matchId,
    required this.teamA,
    required this.teamB,
    required this.result,
    required this.date,
    required this.totalRuns,
    required this.totalWickets,
    this.manOfTheMatch,
  });
}
