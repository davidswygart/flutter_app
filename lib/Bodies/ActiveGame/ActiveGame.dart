import 'package:flutter/material.dart';
import 'package:flutter_app/Bodies/GameMode/CompetitionSettings.dart';

import 'NewGame.dart';
import 'dataStructures/RoundResults.dart';

class ActiveBody extends StatefulWidget {
  final Preset preset;
  const ActiveBody({required this.preset, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ActiveBody(preset: preset);
  }
}

class _ActiveBody extends State<ActiveBody> {
  final Preset preset;
  _ActiveBody({required this.preset});

  final Games game = Games();
  late Widget replayButton;
  late Widget continueButton;
  late Widget restartButton;
  late Widget quitButton;

  @override
  void initState() {
    super.initState();
    replayButton = ElevatedButton(
      onPressed: () {
        game.restartGame();
      },
      child: Text(
        'Replay',
        textScaleFactor: 2,
      ),
    );
    continueButton = ElevatedButton(
      onPressed: () {},
      child: Text(
        'Continue',
        textScaleFactor: 2,
      ),
    );
    restartButton = ElevatedButton(
      onPressed: () {
        game.restartGame();
      },
      child: Text(
        'Restart',
        textScaleFactor: 2,
      ),
    );
    quitButton = ElevatedButton(
      onPressed: () {
        game.quitGame();
      },
      child: Text(
        'Quit',
        textScaleFactor: 2,
      ),
    );
  }

  @override
  void dispose() {
    game.quitGame();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List>(
      stream: game.getStream(),
      initialData: ['preGame'],
      builder: (context, snapshot) {
        if(snapshot.data![0] == 'preGame'){
          return preGame();
        }
        else if (snapshot.data![0] == 'roundResults') {
          return roundResults(snapshot.data![1]);
        }
        else if (snapshot.data![0] == 'endGame'){
          return endGame(snapshot.data![1],snapshot.data![2],snapshot.data![3]);
        }
        else if (snapshot.data![0] == 'targetColor'){
          return targetDisplay(snapshot.data![1]);
        }
        else{
          return Text('Error: unknown stream data');
        }
      }
    );
  }

  Widget preGame(){
    return Center(child: Text('GET READY!',textScaleFactor: 3,),);
  }

  Widget roundResults(RoundResults r){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'ROUND #' + r.roundNum.toString(),
                textScaleFactor: 3,
              ),
            ),
            Divider(
              thickness: 4,
            ),
          ],
        ),
        Column(
          children: [
            Text(r.correctnessFeedback, textScaleFactor: 2),
            Text('Reaction Time: ' + r.reactionTime, textScaleFactor: 2),
            Text('Round score: ' + r.roundScore + ' x ' + r.scoreMultiplier,
                textScaleFactor: 2),
            Text('Total score: ' + r.cumScore, textScaleFactor: 3),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[restartButton, quitButton],
        ),
        ),
      ],
    );
  }
  Widget targetDisplay(List<int> rgb){
     Color c = Color.fromRGBO(rgb[0], rgb[1], rgb[2], 1);
    return Container(color: c,);
  }
  Widget endGame(List<bool> wasCorrect, List<num> reactionTimes, num finalScore){

    List<Widget> scoreList = [Text('ReactionTime',textScaleFactor: 2,)];
    scoreList.add(Divider());

    for (int i = 1; i < reactionTimes.length; i++){
      Color boxColor;
      if(wasCorrect[i]){
        boxColor = Colors.green.shade300;
      }
      else{
        boxColor = Colors.red.shade300;
      }
      scoreList.add(Container(
        child: Text(reactionTimes[i].toString(),textScaleFactor: 1.5,),
        color: boxColor,
        padding: EdgeInsets.all(4),
      ));
      scoreList.add(Divider());
    }
    scoreList.add(Center(child: Text('Final Score',textScaleFactor: 2,),));
    scoreList.add(Divider());
    scoreList.add(Center(child: Text(finalScore.toStringAsFixed(0), textScaleFactor: 3,)));
    

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'End of Game',
                textScaleFactor: 3,
              ),
            ),
            Divider(
              thickness: 4,
            ),
          ],
        ),
        Expanded(child: ListView(children: scoreList),),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[replayButton, continueButton]),
        ),
      ],
    );
  }
}
