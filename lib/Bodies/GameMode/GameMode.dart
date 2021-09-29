import 'package:flutter/material.dart';
import 'package:flutter_app/Bodies/GameMode/AddPresetButton.dart';
import 'package:flutter_app/NavigationDrawer/Drawer.dart';
import 'package:hive/hive.dart';

import '../../AppBar/BlueToothBar.dart';
import '../../main.dart';
import 'CompetitionCarousel.dart';
import 'CompetitionSettings.dart';

class GameModePage extends StatelessWidget {
  const GameModePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlueToothBar(title: 'Game Modes'),
      drawer: NavigationDrawer(),
      body: GameModeBody(),
    );
  }
}

class GameModeBody extends StatelessWidget {
  GameModeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<PresetTemplate> presetBox = Hive.box(savedPresets);
    List<ListTile> customPresetList = [];

    for (PresetTemplate preset in presetBox.values) {
      customPresetList.add(
        ListTile(
          title: Text(preset.title),
        ),
      );
    }

    return ListView(
      children: [
        Container(
          child: Text(
            'Competition Games',
            textScaleFactor: 2,
          ),
          alignment: Alignment.topCenter,
        ),
        CompetitionCarousel(),
        Divider(),
        Container(
          child: Text(
            'Custom Presets',
            textScaleFactor: 2,
          ),
          alignment: Alignment.topCenter,
        ),
        Column(
          children: customPresetList,
        ),
        AddNewPresetButton(),
      ],
    );
  }
}
