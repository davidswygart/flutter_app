import 'package:flutter/material.dart';
import 'package:flutter_app/pages/game/play_go_no_go.dart';
import 'package:flutter_app/pages/game/settings_speed_switcher.dart';

import '../scaffold_wrapper.dart';
import 'choose_game.dart';

class SettingsGoNoGo extends StatefulWidget {
  const SettingsGoNoGo({super.key,});

  @override
  State<SettingsGoNoGo> createState() => _SettingsGoNoGo();
}

class _SettingsGoNoGo extends State<SettingsGoNoGo> {
  double numberOfRounds = 5;
  double maxDelaySeconds = 1;
  double percentGo = 80;
  double timeoutSeconds = 3;

  @override
  Widget build(BuildContext context) {
    Widget primaryColumn = Column(
      children: [
        Image.asset("assets/images/FamilyGuy.gif"),
        const IntroFormat(gameName: 'Go / No Go', numPlayers: '1', numPaddles: '1', description: "Shoot on green, don't shoot on red."),
        const Divider(),
        Text("rounds: ${numberOfRounds.toStringAsFixed(0)}", textScaleFactor: 1.2,),
        getRoundSlider(),
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

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        child:primaryColumn,
      ),
    );
  }

  Widget makePlayButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const IconButton(
          onPressed: null,
          padding: EdgeInsets.zero,
          icon: Icon(Icons.arrow_back, size: 50),
        ),
        ElevatedButton(
          onPressed: () {startGame();},
          child: const Text('Play', textScaleFactor: 1.5,),
        ),
        IconButton(
          onPressed: () {goToNextPage();},
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_forward, size: 50),
        ),
      ],
    );
  }

  startGame(){
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ScaffoldWrapper(
        bodyPage: PlayGoNoGo(
          numberOfRounds: numberOfRounds.toInt(),
          maxPreRoundDelayMs: (maxDelaySeconds*1000).toInt(),
          percentGo: percentGo.toInt(),
          timeoutMs: (timeoutSeconds*1000).toInt(),
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

  goToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScaffoldWrapper(bodyPage: SettingsSpeedSwitcher())),
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