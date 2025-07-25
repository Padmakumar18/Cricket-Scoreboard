import 'package:flutter/material.dart';
import 'package:Frontend/widgets/ScoreSummaryCard.dart';

class ViewScoreBoard extends StatelessWidget {
  final List<BatsmanStats> batsmen;
  final List<BowlerStats> bowlers;

  const ViewScoreBoard({Key? key, required this.batsmen, required this.bowlers})
    : super(key: key);

  Widget _buildBatsmanRow(dynamic b) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              b.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text('${b.runs}')),
          Expanded(child: Text('${b.balls}')),
          Expanded(child: Text('${b.fours}')),
          Expanded(child: Text('${b.sixes}')),
          Expanded(child: Text(b.strikeRate.toStringAsFixed(2))),
        ],
      ),
    );
  }

  Widget _buildBowlerRow(dynamic b) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              b.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text('${b.overs}.${b.totalBalls % 6}')),
          Expanded(child: Text('${b.maidens}')),
          Expanded(child: Text('${b.runs}')),
          Expanded(child: Text('${b.wickets}')),
          Expanded(child: Text(b.economy.toStringAsFixed(2))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/GetMatchDetails',
          (Route<dynamic> route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scorecard'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/GetMatchDetails',
                (Route<dynamic> route) => false,
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Batsmen",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(child: Text("R")),
                    Expanded(child: Text("B")),
                    Expanded(child: Text("4s")),
                    Expanded(child: Text("6s")),
                    Expanded(child: Text("SR")),
                  ],
                ),
                const Divider(),
                ...batsmen.map(_buildBatsmanRow).toList(),
                const SizedBox(height: 24),
                const Text(
                  "Bowlers",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(child: Text("Ov")),
                    Expanded(child: Text("M")),
                    Expanded(child: Text("R")),
                    Expanded(child: Text("W")),
                    Expanded(child: Text("Eco")),
                  ],
                ),
                const Divider(),
                ...bowlers.map(_buildBowlerRow).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
