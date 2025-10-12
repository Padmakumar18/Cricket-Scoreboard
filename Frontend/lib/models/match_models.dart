class Match {
  final String id;
  final String teamA;
  final String teamB;
  final int totalOvers;
  final int playersPerTeam;
  final String tossWinner;
  final bool tossWinnerChoseToBat;
  final DateTime startTime;

  String battingTeam;
  String bowlingTeam;
  bool isFirstInnings;
  String status; // 'ongoing', 'completed', 'abandoned'
  String? result;

  List<Innings> innings;

  Match({
    required this.id,
    required this.teamA,
    required this.teamB,
    required this.totalOvers,
    required this.playersPerTeam,
    required this.tossWinner,
    required this.tossWinnerChoseToBat,
    required this.startTime,
    required this.battingTeam,
    required this.bowlingTeam,
    this.isFirstInnings = true,
    this.status = 'ongoing',
    this.result,
    List<Innings>? innings,
  }) : innings = innings ?? [];

  Map<String, dynamic> toJson() => {
    'id': id,
    'teamA': teamA,
    'teamB': teamB,
    'totalOvers': totalOvers,
    'playersPerTeam': playersPerTeam,
    'tossWinner': tossWinner,
    'tossWinnerChoseToBat': tossWinnerChoseToBat,
    'startTime': startTime.toIso8601String(),
    'battingTeam': battingTeam,
    'bowlingTeam': bowlingTeam,
    'isFirstInnings': isFirstInnings,
    'status': status,
    'result': result,
    'innings': innings.map((i) => i.toJson()).toList(),
  };

  factory Match.fromJson(Map<String, dynamic> json) => Match(
    id: json['id'],
    teamA: json['teamA'],
    teamB: json['teamB'],
    totalOvers: json['totalOvers'],
    playersPerTeam: json['playersPerTeam'],
    tossWinner: json['tossWinner'],
    tossWinnerChoseToBat: json['tossWinnerChoseToBat'],
    startTime: DateTime.parse(json['startTime']),
    battingTeam: json['battingTeam'],
    bowlingTeam: json['bowlingTeam'],
    isFirstInnings: json['isFirstInnings'] ?? true,
    status: json['status'] ?? 'ongoing',
    result: json['result'],
    innings:
        (json['innings'] as List?)?.map((i) => Innings.fromJson(i)).toList() ??
        [],
  );
}

class Innings {
  final String battingTeam;
  final String bowlingTeam;
  final int inningsNumber;

  int totalRuns;
  int wickets;
  int overs;
  int balls;
  int extras;
  double currentRunRate;

  List<BatsmanStats> batsmen;
  List<BowlerStats> bowlers;
  List<Over> oversData;
  List<Wicket> fallOfWickets;

  Innings({
    required this.battingTeam,
    required this.bowlingTeam,
    required this.inningsNumber,
    this.totalRuns = 0,
    this.wickets = 0,
    this.overs = 0,
    this.balls = 0,
    this.extras = 0,
    this.currentRunRate = 0.0,
    List<BatsmanStats>? batsmen,
    List<BowlerStats>? bowlers,
    List<Over>? oversData,
    List<Wicket>? fallOfWickets,
  }) : batsmen = batsmen ?? [],
       bowlers = bowlers ?? [],
       oversData = oversData ?? [],
       fallOfWickets = fallOfWickets ?? [];

  Map<String, dynamic> toJson() => {
    'battingTeam': battingTeam,
    'bowlingTeam': bowlingTeam,
    'inningsNumber': inningsNumber,
    'totalRuns': totalRuns,
    'wickets': wickets,
    'overs': overs,
    'balls': balls,
    'extras': extras,
    'currentRunRate': currentRunRate,
    'batsmen': batsmen.map((b) => b.toJson()).toList(),
    'bowlers': bowlers.map((b) => b.toJson()).toList(),
    'oversData': oversData.map((o) => o.toJson()).toList(),
    'fallOfWickets': fallOfWickets.map((w) => w.toJson()).toList(),
  };

  factory Innings.fromJson(Map<String, dynamic> json) => Innings(
    battingTeam: json['battingTeam'],
    bowlingTeam: json['bowlingTeam'],
    inningsNumber: json['inningsNumber'],
    totalRuns: json['totalRuns'] ?? 0,
    wickets: json['wickets'] ?? 0,
    overs: json['overs'] ?? 0,
    balls: json['balls'] ?? 0,
    extras: json['extras'] ?? 0,
    currentRunRate: json['currentRunRate']?.toDouble() ?? 0.0,
    batsmen:
        (json['batsmen'] as List?)
            ?.map((b) => BatsmanStats.fromJson(b))
            .toList() ??
        [],
    bowlers:
        (json['bowlers'] as List?)
            ?.map((b) => BowlerStats.fromJson(b))
            .toList() ??
        [],
    oversData:
        (json['oversData'] as List?)?.map((o) => Over.fromJson(o)).toList() ??
        [],
    fallOfWickets:
        (json['fallOfWickets'] as List?)
            ?.map((w) => Wicket.fromJson(w))
            .toList() ??
        [],
  );
}

class BatsmanStats {
  String name;
  int runs;
  int balls;
  int fours;
  int sixes;
  double strikeRate;
  bool isOut;
  String? dismissalType;
  String? bowlerName;
  String? fielderName;
  bool isOnStrike;

  BatsmanStats({
    required this.name,
    this.runs = 0,
    this.balls = 0,
    this.fours = 0,
    this.sixes = 0,
    this.strikeRate = 0.0,
    this.isOut = false,
    this.dismissalType,
    this.bowlerName,
    this.fielderName,
    this.isOnStrike = false,
  });

  void updateStats(int runsScored) {
    runs += runsScored;
    balls++;
    if (runsScored == 4) fours++;
    if (runsScored == 6) sixes++;
    strikeRate = balls > 0 ? (runs / balls) * 100 : 0.0;
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'runs': runs,
    'balls': balls,
    'fours': fours,
    'sixes': sixes,
    'strikeRate': strikeRate,
    'isOut': isOut,
    'dismissalType': dismissalType,
    'bowlerName': bowlerName,
    'fielderName': fielderName,
    'isOnStrike': isOnStrike,
  };

  factory BatsmanStats.fromJson(Map<String, dynamic> json) => BatsmanStats(
    name: json['name'],
    runs: json['runs'] ?? 0,
    balls: json['balls'] ?? 0,
    fours: json['fours'] ?? 0,
    sixes: json['sixes'] ?? 0,
    strikeRate: json['strikeRate']?.toDouble() ?? 0.0,
    isOut: json['isOut'] ?? false,
    dismissalType: json['dismissalType'],
    bowlerName: json['bowlerName'],
    fielderName: json['fielderName'],
    isOnStrike: json['isOnStrike'] ?? false,
  );
}

class BowlerStats {
  String name;
  int overs;
  int balls;
  int maidens;
  int runs;
  int wickets;
  double economy;
  bool isCurrentBowler;

  BowlerStats({
    required this.name,
    this.overs = 0,
    this.balls = 0,
    this.maidens = 0,
    this.runs = 0,
    this.wickets = 0,
    this.economy = 0.0,
    this.isCurrentBowler = false,
  });

  void updateStats(int runsGiven, bool isWicket) {
    runs += runsGiven;
    balls++;
    if (balls % 6 == 0) {
      overs++;
      balls = 0;
    }
    if (isWicket) wickets++;

    double totalOvers = overs + (balls / 6.0);
    economy = totalOvers > 0 ? runs / totalOvers : 0.0;
  }

  String get oversString => '$overs.$balls';

  Map<String, dynamic> toJson() => {
    'name': name,
    'overs': overs,
    'balls': balls,
    'maidens': maidens,
    'runs': runs,
    'wickets': wickets,
    'economy': economy,
    'isCurrentBowler': isCurrentBowler,
  };

  factory BowlerStats.fromJson(Map<String, dynamic> json) => BowlerStats(
    name: json['name'],
    overs: json['overs'] ?? 0,
    balls: json['balls'] ?? 0,
    maidens: json['maidens'] ?? 0,
    runs: json['runs'] ?? 0,
    wickets: json['wickets'] ?? 0,
    economy: json['economy']?.toDouble() ?? 0.0,
    isCurrentBowler: json['isCurrentBowler'] ?? false,
  );
}

class Over {
  final int overNumber;
  final String bowlerName;
  final List<Ball> balls;
  int runs;
  int wickets;

  Over({
    required this.overNumber,
    required this.bowlerName,
    List<Ball>? balls,
    this.runs = 0,
    this.wickets = 0,
  }) : balls = balls ?? [];

  Map<String, dynamic> toJson() => {
    'overNumber': overNumber,
    'bowlerName': bowlerName,
    'balls': balls.map((b) => b.toJson()).toList(),
    'runs': runs,
    'wickets': wickets,
  };

  factory Over.fromJson(Map<String, dynamic> json) => Over(
    overNumber: json['overNumber'],
    bowlerName: json['bowlerName'],
    balls:
        (json['balls'] as List?)?.map((b) => Ball.fromJson(b)).toList() ?? [],
    runs: json['runs'] ?? 0,
    wickets: json['wickets'] ?? 0,
  );
}

class Ball {
  final int runs;
  final bool isWide;
  final bool isNoBall;
  final bool isBye;
  final bool isLegBye;
  final bool isWicket;
  final String? wicketType;
  final String? batsmanName;
  final String display;

  Ball({
    required this.runs,
    this.isWide = false,
    this.isNoBall = false,
    this.isBye = false,
    this.isLegBye = false,
    this.isWicket = false,
    this.wicketType,
    this.batsmanName,
    required this.display,
  });

  bool get isExtra => isWide || isNoBall || isBye || isLegBye;
  bool get isLegalDelivery => !isWide && !isNoBall;

  Map<String, dynamic> toJson() => {
    'runs': runs,
    'isWide': isWide,
    'isNoBall': isNoBall,
    'isBye': isBye,
    'isLegBye': isLegBye,
    'isWicket': isWicket,
    'wicketType': wicketType,
    'batsmanName': batsmanName,
    'display': display,
  };

  factory Ball.fromJson(Map<String, dynamic> json) => Ball(
    runs: json['runs'],
    isWide: json['isWide'] ?? false,
    isNoBall: json['isNoBall'] ?? false,
    isBye: json['isBye'] ?? false,
    isLegBye: json['isLegBye'] ?? false,
    isWicket: json['isWicket'] ?? false,
    wicketType: json['wicketType'],
    batsmanName: json['batsmanName'],
    display: json['display'],
  );
}

class Wicket {
  final String batsmanName;
  final String dismissalType;
  final String? bowlerName;
  final String? fielderName;
  final int runs;
  final int wickets;
  final double overs;

  Wicket({
    required this.batsmanName,
    required this.dismissalType,
    this.bowlerName,
    this.fielderName,
    required this.runs,
    required this.wickets,
    required this.overs,
  });

  Map<String, dynamic> toJson() => {
    'batsmanName': batsmanName,
    'dismissalType': dismissalType,
    'bowlerName': bowlerName,
    'fielderName': fielderName,
    'runs': runs,
    'wickets': wickets,
    'overs': overs,
  };

  factory Wicket.fromJson(Map<String, dynamic> json) => Wicket(
    batsmanName: json['batsmanName'],
    dismissalType: json['dismissalType'],
    bowlerName: json['bowlerName'],
    fielderName: json['fielderName'],
    runs: json['runs'],
    wickets: json['wickets'],
    overs: json['overs']?.toDouble() ?? 0.0,
  );
}
