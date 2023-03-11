import 'package:flutter/material.dart';
import 'package:flutter_app/pages/game/play_speed_switcher.dart';

import '../scaffold_wrapper.dart';
import 'choose_game.dart';

class SettingsSpeedSwitcher extends StatefulWidget {
  const SettingsSpeedSwitcher({super.key,});

  @override
  State<SettingsSpeedSwitcher> createState() => _SettingsSpeedSwitcher();
}

class _SettingsSpeedSwitcher extends State<SettingsSpeedSwitcher> {
  double numberOfRounds = 5;
  double maxDelaySeconds = 1;
  double speedDecreasePercent = 20;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("assets/images/bender.gif"),
        const IntroFormat(gameName: 'Speed Switcher', numPlayers: '1-3', numPaddles: '1', description: "Target switches between red, green, and blue. Shoot your color as fast as possible."),
        const Divider(),
        Text("rounds: ${numberOfRounds.toStringAsFixed(0)}", textScaleFactor: 1.2,),
        getRoundSlider(),
        const Divider(),
        Text("Pre-round delay: ${maxDelaySeconds.toStringAsFixed(1)} s", textScaleFactor: 1.2,),
        getDelaySlider(),
        const Divider(),
        Text("Speed Decrease: ${speedDecreasePercent.toStringAsFixed(0)}%", textScaleFactor: 1.2,),
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
          bodyPage: PlaySpeedSwitcher(
            numberOfRounds: numberOfRounds.toInt(),
            maxPreRoundDelayMs: (maxDelaySeconds*1000).toInt(),
            speedDecreasePercent: speedDecreasePercent.toInt(),
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
        min: 1,
        max: 50,
        divisions: 49,
        value: speedDecreasePercent,
        label: null,//speedDecreasePercent.toStringAsFixed(0),
        onChanged: (double value) {
          setState((){speedDecreasePercent = value;});
        }
    );
  }
}