import 'package:flutter/material.dart';
import 'package:flutter_app/pages/game/play_color_discrimination.dart';

import '../scaffold_wrapper.dart';
import 'choose_game.dart';

class SettingsColorDiscrimination extends StatefulWidget {
  const SettingsColorDiscrimination({super.key,});

  @override
  State<SettingsColorDiscrimination> createState() => _SettingsColorDiscrimination();
}

class _SettingsColorDiscrimination extends State<SettingsColorDiscrimination> {
  double maxDelaySeconds = 1;
  double convergencePercent = 30;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("assets/images/Mcgrubber.gif"),
        const IntroFormat(gameName: 'Color Discrimination', numPlayers: '1', numPaddles: '2', description: "Shoot the target that is more green."),
        const Divider(),
        Text("Pre-round delay: ${maxDelaySeconds.toStringAsFixed(1)} s", textScaleFactor: 1.2,),
        getDelaySlider(),
        const Divider(),
        Text("Rate of convergence: ${convergencePercent.toStringAsFixed(0)}%", textScaleFactor: 1.2,),
        getConvergenceSlider(),
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
          bodyPage: PlayColorDiscrimination(
            maxPreRoundDelayMs: (maxDelaySeconds*1000).toInt(),
            convergencePercent: convergencePercent.toInt(),
          ),
      );
    }));
  }

  getDelaySlider(){
    return Slider(
        min: 0,
        max: 20,
        divisions: 200,
        value: maxDelaySeconds,
        label: maxDelaySeconds.toStringAsFixed(1),
        onChanged: (double value) {
          setState((){maxDelaySeconds = value;});
        }
    );
  }

  getConvergenceSlider(){
    return Slider(
        min: 10,
        max: 80,
        divisions: 70,
        value: convergencePercent,
        label: convergencePercent.toStringAsFixed(0),
        onChanged: (double value) {
          setState((){convergencePercent = value;});
        }
    );
  }
}