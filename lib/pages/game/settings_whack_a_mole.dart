import 'package:flutter/material.dart';
import 'package:flutter_app/pages/game/play_whack_a_mole.dart';
import '../scaffold_wrapper.dart';
import 'choose_game.dart';

class SettingsWhackAMole extends StatefulWidget {
  const SettingsWhackAMole({super.key,});

  @override
  State<SettingsWhackAMole> createState() => _SettingsWhackAMole();
}

class _SettingsWhackAMole extends State<SettingsWhackAMole> {
  double gameTimeout = 30;
  double maxDelaySeconds = 1;
  double percentGo = 80;
  double timeoutSeconds = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("assets/images/FamilyGuy.gif"),
        const IntroFormat(gameName: 'Whack-a-Mole', numPlayers: '1', numPaddles: '2+', description: "Shoot on green, don't shoot on red."),
        const Divider(),
        Text("Game length: ${gameTimeout.toStringAsFixed(0)} s", textScaleFactor: 1.2,),
        getGameTimeoutSlider(),
        const Divider(),
        Text("Pre-round delay: ${maxDelaySeconds.toStringAsFixed(1)} s", textScaleFactor: 1.2,),
        getDelaySlider(),
        const Divider(),
        Text("Timeout: ${timeoutSeconds.toStringAsFixed(1)} s", textScaleFactor: 1.2,),
        getTimeoutSlider(),
        const Divider(),
        Text("Go percentage: ${percentGo.toStringAsFixed(0)}%", textScaleFactor: 1.2,),
        getGoPercentSlider(),
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
          bodyPage: PlayWhackAMole(
            maxPreRoundDelayMs: (maxDelaySeconds*1000).toInt(),
            percentGo: percentGo.toInt(),
            timeoutMs: (timeoutSeconds*1000).toInt(),
            gameTimeLimitSeconds: gameTimeout.toInt(),
          ),
      );
    }));
  }

  getGameTimeoutSlider(){
    return Slider(
        min: 5,
        max: 200,
        divisions: 190,
        value: gameTimeout,
        label: null,//numberOfRounds.toStringAsFixed(0),
        onChanged: (double value) {
          setState((){gameTimeout = value;});
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

  getTimeoutSlider(){
    return Slider(
        min: 0.5,
        max: 10,
        divisions: 95,
        value: timeoutSeconds,
        label: null,//timeoutSeconds.toStringAsFixed(1),
        onChanged: (double value) {
          setState((){timeoutSeconds = value;});
        }
    );
  }

  getGoPercentSlider(){
    return Slider(
        min: 1,
        max: 100,
        divisions: 99,
        value: percentGo,
        label: null,//percentGo.toStringAsFixed(0),
        onChanged: (double value) {
          setState((){percentGo = value;});
        }
    );
  }
}