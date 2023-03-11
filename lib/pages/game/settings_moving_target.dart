import 'package:flutter/material.dart';
import 'package:flutter_app/pages/game/play_moving_target.dart';

import '../scaffold_wrapper.dart';
import 'choose_game.dart';

class SettingsMovingTarget extends StatefulWidget {
  const SettingsMovingTarget({super.key,});

  @override
  State<SettingsMovingTarget> createState() => _SettingsMovingTarget();
}

class _SettingsMovingTarget extends State<SettingsMovingTarget> {
  double numberOfRounds = 5;
  double maxDelaySeconds = 1;
  double moveSpeedHz = 0.5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("assets/images/McBride.gif"),
        const IntroFormat(gameName: 'Moving Target', numPlayers: '1-3', numPaddles: '2+', description: "Pick a color and shoot it. But they switch between targets."),
        const Divider(),
        Text("rounds: ${numberOfRounds.toStringAsFixed(0)}", textScaleFactor: 1.2,),
        getRoundSlider(),
        const Divider(),
        Text("Pre-round delay: ${maxDelaySeconds.toStringAsFixed(1)} s", textScaleFactor: 1.2,),
        getDelaySlider(),
        const Divider(),
        Text("Switching speed: ${moveSpeedHz.toStringAsFixed(1)} Hz", textScaleFactor: 1.2,),
        getSpeedSlider(),
        const Divider(),
        makePlayButton(),
      ],
    );
  }

  Widget makePlayButton() {
    return ElevatedButton(
      onPressed: () {startGame();},
      child: const Text('Play', textScaleFactor: 1.5,),
    );
  }

  startGame(){
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ScaffoldWrapper(
          bodyPage: PlayMovingTarget(
            numberOfRounds: numberOfRounds.toInt(),
            maxPreRoundDelayMs: (maxDelaySeconds*1000).toInt(),
            pauseMillis: 1000~/moveSpeedHz,
          ),
      );
    }));
  }

  getRoundSlider(){
    return Slider(
        min: 1,
        max: 20,
        divisions: 19,
        value: numberOfRounds,
        label: null,//numberOfRounds.toStringAsFixed(0),
        onChanged: (double value) {
          setState((){numberOfRounds = value;});
        }
    );
  }

  getDelaySlider(){
    return Slider(
        min: 0,
        max: 20,
        divisions: 200,
        value: maxDelaySeconds,
        label: null,//maxDelaySeconds.toStringAsFixed(1),
        onChanged: (double value) {
          setState((){maxDelaySeconds = value;});
        }
    );
  }

  getSpeedSlider(){
    return Slider(
        min: 0.1,
        max: 2,
        divisions: 19,
        value: moveSpeedHz,
        label: null,//moveSpeedHz.toStringAsFixed(1),
        onChanged: (double value) {
          setState((){moveSpeedHz = value;});
        }
    );
  }
}