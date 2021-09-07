import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ChangeNotifiers/CustomPresetChangeNotifier.dart';
import 'package:provider/provider.dart';

import '../../AppBar/BlueToothBar.dart';


class PresetPage extends StatelessWidget {
  const PresetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BlueToothBar(title: 'Game Modes'),
      body: const PresetBody(),
    );
  }
}

class PresetBody extends StatelessWidget {
  const PresetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomPresetNotifier>(
        builder: (context, customPresetNotifier, child) {
          return customPresetNotifier.listView;
        }
        );
  }
}
