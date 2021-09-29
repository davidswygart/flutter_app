import 'package:flutter/material.dart';
import 'package:flutter_app/AppBar/BlueToothBar.dart';
import 'package:flutter_app/Bodies/GameMode/CompetitionSettings.dart';
import 'package:flutter_app/Bodies/GameSettings/PlayerColumn/PlayerColumn.dart';
import 'package:flutter_app/NavigationDrawer/Drawer.dart';

import '../../AdvanceButton.dart';
import 'ColorRow/ColorRow.dart';

class GameSettingsPage extends StatelessWidget {
  const GameSettingsPage({Key? key}) : super(key: key);

  static const routeName = '/GameSettings';

  @override
  Widget build(BuildContext context) {
    final preset = ModalRoute.of(context)!.settings.arguments as PresetTemplate;

    return Scaffold(
      appBar: BlueToothBar(
        title: 'Game Settings',
      ),
      drawer: NavigationDrawer(),
      body: GameSettingsBody(preset: preset),
      floatingActionButton: AdvanceButton(
        route: '/ActiveGame',
        text: 'Start Game',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class GameSettingsBody extends StatefulWidget {
  final PresetTemplate preset;
  const GameSettingsBody({required this.preset, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GameSettingsBody(preset: preset);
  }
}

class _GameSettingsBody extends State<GameSettingsBody> {
  PresetTemplate preset;
  late bool moveON;
  late bool lTimeoutON;
  late bool rTimeoutON;

  _GameSettingsBody({required this.preset}) {
    moveON = preset.moveSpeed > 0;
    rTimeoutON = preset.roundTimeout > 0;
    lTimeoutON = preset.lightTimeout > 0;
  }

  @override
  Widget build(BuildContext context) {
    List<String> labels;
    if (preset.colorInOrder){
      labels = ['Chris', 'Sarah', 'Ben', 'Albert Einstein'];
    }
    else {
      labels = ['1st', '2nd', '3rd', '4th'];
    }

    return ListView(
      children: [
        Card(
          margin: EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  preset.title,
                  textScaleFactor: 1.3,
                ),
              ),
              Flexible(
                child: Text(
                  preset.description,
                ),
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.all(5),
          child: PlayerColumn(),
        ),
        Card(
          margin: EdgeInsets.all(5),
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Number of Rounds'),
                    Text(preset.numRounds.toString()),
                  ],
                ),
                Slider(
                  value: preset.numRounds.toDouble(),
                  label: preset.numRounds.toString(),
                  onChanged: (double newVal) {
                    setState(() => preset.numRounds = newVal.toInt());
                  },
                  min: 0,
                  max: 20,
                  divisions: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Delay Between Rounds'),
                    Text(preset.roundDelay.toString() + ' Seconds'),
                  ],
                ),
                Slider(
                  value: preset.roundDelay,
                  label: preset.roundDelay.toStringAsFixed(1),
                  onChanged: (double newVal) {
                    setState(() => preset.roundDelay =
                        double.parse(newVal.toStringAsFixed(1)));
                  },
                  min: 0,
                  max: 20,
                  //divisions: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Randomness of Delay'),
                    Text(preset.delayRandomness.toString() + ' Seconds'),
                  ],
                ),
                Slider(
                  value: preset.delayRandomness,
                  label: preset.delayRandomness.toStringAsFixed(1),
                  onChanged: (double newVal) {
                    setState(() => preset.delayRandomness =
                        double.parse(newVal.toStringAsFixed(1)));
                  },
                  min: 0,
                  max: 20,
                  //divisions: 100,
                ),
              ],
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.all(5),
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Movement'),
                    Switch(
                      value: moveON,
                      onChanged: (bool value) {
                        setState(() {
                          moveON = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text((moveON ? preset.moveSpeed.toString() : '0') +
                        ' Switches/second')
                  ],
                ),
                Slider(
                  value: preset.moveSpeed,
                  min: 0,
                  max: 4,
                  onChanged: moveON
                      ? (double newVal) {
                          setState(() => preset.moveSpeed =
                              double.parse(newVal.toStringAsFixed(1)));
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.all(5),
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Round Timeout'),
                    Switch(
                      value: rTimeoutON,
                      onChanged: (bool value) {
                        setState(() {
                          rTimeoutON = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text((rTimeoutON
                            ? preset.roundTimeout.toString()
                            : 'infinity') +
                        ' seconds')
                  ],
                ),
                Slider(
                  value: preset.roundTimeout,
                  min: 0,
                  max: 20,
                  onChanged: rTimeoutON
                      ? (double newVal) {
                          setState(() => preset.roundTimeout =
                              double.parse(newVal.toStringAsFixed(1)));
                        }
                      : null,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Indicator Light Timeout'),
                    Switch(
                      value: lTimeoutON,
                      onChanged: (bool value) {
                        setState(() {
                          lTimeoutON = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text((lTimeoutON
                            ? preset.lightTimeout.toString()
                            : 'infinity') +
                        ' seconds')
                  ],
                ),
                Slider(
                  value: preset.lightTimeout,
                  min: 0,
                  max: 20,
                  onChanged: lTimeoutON
                      ? (double newVal) {
                          setState(() => preset.lightTimeout =
                              double.parse(newVal.toStringAsFixed(1)));
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.all(5),
          child: Column(
            children: [
              RadioListTile(
                groupValue: preset.colorInOrder,
                value: true,
                title: Text('Color in Order'),
                onChanged: (bool? value) {
                  setState(() {
                    preset.colorInOrder = true;
                  });
                },
              ),
              RadioListTile(
                groupValue: preset.colorInOrder,
                value: false,
                title: Text('Simultaneous play'),
                onChanged: (bool? value) {
                  setState(() {
                    preset.colorInOrder = false;
                  });
                },
              ),
              ColorRow(labels: labels),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Save Copy'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Delete'),
            ),
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height / 3,
        ),
      ],
    );
  }
}
