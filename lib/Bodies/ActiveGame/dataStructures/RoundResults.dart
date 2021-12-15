class RoundResults {
  int roundNum;
  bool isCorrect;
  String correctnessFeedback;
  String blame;
  String reactionTime;
  String scoreMultiplier;
  String roundScore;
  String cumScore;

  RoundResults({
    this.roundNum = 0, //0 start of game, -1 end of game
    this.isCorrect = false,
    this.correctnessFeedback = 'null',
    this.blame = 'null',
    this.reactionTime = 'NA',
    this.scoreMultiplier = '0',
    this.roundScore = '0',
    this.cumScore = '0',
  });
}
