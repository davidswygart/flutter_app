import 'package:flutter/material.dart';
import 'package:flutter_app/pages/game/play_memory.dart';

import '../scaffold_wrapper.dart';
import 'choose_game.dart';

class SettingsMemory extends StatefulWidget {
  const SettingsMemory({super.key,});

  @override
  State<SettingsMemory> createState() => _SettingsMemory();
}

class _SettingsMemory extends State<SettingsMemory> {
  double maxDelaySeconds = 1;
  double moveSpeedHz = 0.5;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Image.asset("assets/images/Office.gif"),
            const IntroFormat(gameName: 'Sequential Memory', numPlayers: '1', numPaddles: '2+', description: "Shoot the target in the same order as the prompt."),
            const Divider(),
            Text("Pre-round delay: ${maxDelaySeconds.toStringAsFixed(1)} s", textScaleFactor: 1.2,),
            getDelaySlider(),
            const Divider(),
            Text("Switching speed: ${moveSpeedHz.toStringAsFixed(1)} Hz", textScaleFactor: 1.2,),
            getSpeedSlider(),
            const Divider(),
            makePlayButton(),
          ],
        ),
      ),
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
          bodyPage: PlayMemory(
            maxPreRoundDelayMs: (maxDelaySeconds*1000).toInt(),
            flashDelayMs: 1000/moveSpeedHz~/2, //divide delay in two because it is used for on and off
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

  getSpeedSlider(){
    return Slider(
        min: 0.1,
        max: 2,
        divisions: 19,
        value: moveSpeedHz,
        label: moveSpeedHz.toStringAsFixed(1),
        onChanged: (double value) {
          setState((){moveSpeedHz = value;});
        }
    );
  }
}