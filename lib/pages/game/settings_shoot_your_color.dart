import 'package:flutter/material.dart';
import 'package:flutter_app/pages/game/play_shoot_your_color.dart';
import '../scaffold_wrapper.dart';
import 'choose_game.dart';

class SettingsShootYourColor extends StatefulWidget {
  const SettingsShootYourColor({super.key,});

  @override
  State<SettingsShootYourColor> createState() => _SettingsShootYourColor();
}

class _SettingsShootYourColor extends State<SettingsShootYourColor> {
  double numberOfRounds = 5;
  double maxDelaySeconds = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("assets/images/Smosh.gif"),
        const IntroFormat(gameName: 'Shoot your color', numPlayers: '1-3', numPaddles: '2+', description: "Pick a color and shoot it."),
        const Divider(),
        Text("rounds: ${numberOfRounds.toStringAsFixed(0)}", textScaleFactor: 1.2,),
        getRoundSlider(),
        const Divider(),
        Text("Pre-round delay: ${maxDelaySeconds.toStringAsFixed(1)} s", textScaleFactor: 1.2,),
        getDelaySlider(),
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
          bodyPage: PlayShootYourColor(
            numberOfRounds: numberOfRounds.toInt(),
            maxPreRoundDelayMs: (maxDelaySeconds*1000).toInt(),
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
}