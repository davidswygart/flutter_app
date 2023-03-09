import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  final int totalRounds;
  final int currentRound;
  final List<int> hits;
  final List<int> reactionTimes;
  final List<int> scores;

  const ScoreBoard({
    super.key,
    required this.totalRounds,
    required this.currentRound,
    required this.hits,
    required this.reactionTimes,
    required this.scores
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          formatTitles("Round: ${currentRound+1}/ $totalRounds"), // add 1 with the assumption of 0 indexing
          const Divider(),
          formatTitles("Hits:"),
          makeColoredNumbersRow(hits),
          const Divider(),
          formatTitles("Reaction time (ms):"),
          makeColoredNumbersRow(reactionTimes),
          const Divider(),
          formatTitles("Score:"),
          makeColoredNumbersRow(scores),
          const Divider(),
          ]
    );
  }

  formatTitles(String str) {
    return Center(
        child: Text(str,
            textScaleFactor: 1.5,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            )));
  }


  Widget makeColoredNumbersRow(scoreList) {
    List<Color> colorOrder = [
      Colors.green.shade800,
      Colors.blue.shade800,
      Colors.red.shade800,
    ];
    List<Text> textList = [];
    for (int i = 0; i < scoreList.length; i++) {
      textList.add(Text(
        scoreList[i].toString(),
        textScaleFactor: 1.5,
        style: TextStyle(
          color: colorOrder[i],
          fontWeight: FontWeight.bold,
        ),
      ));
    }
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: textList,
      ),
    );
  }
}