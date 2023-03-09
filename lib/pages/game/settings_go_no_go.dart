
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/game/play_go_no_go.dart';

import '../scaffold_wrapper.dart';
import 'active_game_page.dart';
import 'choose_game.dart';

class SettingsGoNoGo extends StatefulWidget{
  const SettingsGoNoGo({super.key,});
  @override
  State<SettingsGoNoGo> createState() => _SettingsGoNoGo();
}

class _SettingsGoNoGo extends State<SettingsGoNoGo> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Image.asset("assets/images/FamilyGuy.gif"),
            const IntroFormat(gameName: 'Go / No Go', numPlayers: '1', numPaddles: '1', description: "Shoot on green, don't shoot on red."),
            const Divider(),
            //roundTitle,
            //roundSlider,
            const Divider(),
            //roundDelayTitle,
            //roundDelaySlider,
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
      return const ScaffoldWrapper(
          bodyPage: PlayGoNoGo(
            numberOfRounds: 5,
            maxPreRoundDelayMs: 2000,
            percentGo: 80,
            timeoutMs: 3000,
          ),
      );
    }));
  }


  //
  // Widget roundTitle = Text(
  //   "${widget.settings.numberOfRounds} rounds",
  //   textScaleFactor: 1.2,
  // );
  //
  // Widget roundSlider = Slider(
  //     min: 1,
  //     max: 20,
  //     value: widget.settings.numberOfRounds.toDouble(),
  //     label: widget.settings.numberOfRounds.toString(),
  //     divisions: 19,
  //     onChanged: (double value) {
  //       setState((){widget.settings.numberOfRounds = value.toInt();});
  //     }
  // );
  //
  // Widget roundDelayTitle = Text(
  //   "${widget.settings.maxPreRoundDelaySeconds} s max round delay",
  //   textScaleFactor: 1.2,
  // );
  //
  // Widget roundDelaySlider = Slider(
  //     min: 0,
  //     max: 5,
  //     value: widget.settings.maxPreRoundDelaySeconds,
  //     label: widget.settings.maxPreRoundDelaySeconds.toString(),
  //     divisions: 25,
  //     onChanged: (double value) {
  //       String roundedString = value.toStringAsFixed(2);
  //       double newVal = double.parse(roundedString);
  //       setState((){widget.settings.maxPreRoundDelaySeconds = newVal;});
  //     }
  // );
}