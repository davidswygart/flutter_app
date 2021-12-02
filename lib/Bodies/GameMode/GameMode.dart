import 'package:flutter/material.dart';
import 'package:flutter_app/Bodies/GameMode/AddPresetButton.dart';
import 'package:hive/hive.dart';


import 'CompetitionCarousel.dart';
import 'CompetitionSettings.dart';


class GameModeBody extends StatelessWidget {
  GameModeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<Preset> presetBox = Hive.box(Preset.boxName);
    List<ListTile> customPresetList = [];

    for (Preset preset in presetBox.values) {
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
            'Custom Games',
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
