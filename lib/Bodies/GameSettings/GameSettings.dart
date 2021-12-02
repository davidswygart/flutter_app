import 'package:flutter/material.dart';
import 'package:flutter_app/Bodies/GameMode/CompetitionSettings.dart';

import 'ColorRow/ColorRow.dart';


class GameSettingsBody extends StatefulWidget {
  final Preset preset;
  const GameSettingsBody({required this.preset, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GameSettingsBody(preset: preset);
  }
}

class _GameSettingsBody extends State<GameSettingsBody> {
  Preset preset;
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

    List<String> labels = ['1st', '2nd', '3rd', '4th'];

    Widget titleDesc = Column(
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
    );
    Widget rounds = Container(
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
            onChanged: preset.editable ? (double newVal) {
              setState(() => preset.numRounds = newVal.toInt());
            } : null,
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
            onChanged: preset.editable ? (double newVal) {
              setState(() => preset.roundDelay =
                  double.parse(newVal.toStringAsFixed(1)));
            } : null,
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
            onChanged: preset.editable ? (double newVal) {
              setState(() => preset.delayRandomness =
                  double.parse(newVal.toStringAsFixed(1)));
            } : null,
            min: 0,
            max: 20,
            //divisions: 100,
          ),
        ],
      ),
    );
    Widget movement = Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Movement'),
              Switch(
                value: moveON,
                onChanged: preset.editable ? (bool value){setState(() {moveON = value;});} : null,
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
            onChanged: moveON & preset.editable ? (double newVal) {
              setState(() => preset.moveSpeed =
                  double.parse(newVal.toStringAsFixed(1)));
            }
                : null,
          ),
        ],
      ),
    );
    Widget timeout = Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Round Timeout'),
              Switch(
                value: rTimeoutON,
                onChanged: preset.editable ?
                    (bool value) {setState(() {rTimeoutON = value;});}
                    : null,
              ),
            ],
          ),
          Text((rTimeoutON
                  ? preset.roundTimeout.toString()
                  : 'infinity') +
                  ' seconds'),
          Slider(
            value: preset.roundTimeout,
            min: 0,
            max: 20,
            onChanged: rTimeoutON & preset.editable
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
                onChanged: preset.editable ?
                    (bool value) {setState(() {lTimeoutON = value;});}
                    : null,
              ),
            ],
          ),
          Text((lTimeoutON
              ? preset.lightTimeout.toString()
              : 'infinity')
              + ' seconds'),
          Slider(
            value: preset.lightTimeout,
            min: 0,
            max: 20,
            onChanged: lTimeoutON & preset.editable
                ? (double newVal) {
              setState(() => preset.lightTimeout = double.parse(newVal.toStringAsFixed(1)));
            }
                : null,
          ),
        ],
      ),
    );
    Widget primaryMode = Column(
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
        RadioListTile(
          groupValue: preset.colorInOrder,
          value: false,
          title: Text('Sequential Memory'),
          onChanged: (bool? value) {
            setState(() {
              preset.colorInOrder = false;
            });
          },
        ),
        ColorRow(labels: labels),
      ],
    );

    return ListView(
      children: [
        Card(
          margin: EdgeInsets.all(5),
          child: titleDesc,
        ),
        Card(
          margin: EdgeInsets.all(5),
          child: rounds,
        ),
        Card(
          margin: EdgeInsets.all(5),
          child: primaryMode,
        ),
        Card(
          margin: EdgeInsets.all(5),
          child: movement,
        ),
        Card(
          margin: EdgeInsets.all(5),
          child: timeout,
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