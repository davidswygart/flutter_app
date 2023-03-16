import 'package:flutter/material.dart';
import 'package:flutter_app/pages/game/play_simone_says.dart';
import '../scaffold_wrapper.dart';
import 'choose_game.dart';

class SettingsSimoneSays extends StatefulWidget {
  const SettingsSimoneSays({super.key,});

  @override
  State<SettingsSimoneSays> createState() => _SettingsSimoneSays();
}

class _SettingsSimoneSays extends State<SettingsSimoneSays> {
  double numberOfRounds = 5;
  double maxDelaySeconds = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("assets/images/Smosh.gif"),
        const IntroFormat(gameName: 'Simone Says', numPlayers: '1', numPaddles: '2+', description: "Listen to phone audio and shoot instructed color"),
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
          bodyPage: PlaySimoneSays(
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