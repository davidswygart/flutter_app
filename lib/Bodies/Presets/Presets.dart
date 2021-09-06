import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ChangeNotifyers/CustomPresetChangeNotifyer.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../AppBar/BlueToothBar.dart';
import 'Accordions/PresetAccordion.dart';
import 'AddPresetButton/AddPresetButton.dart';
import 'CompetitionSettings.dart';

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

  static const TextStyle titleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 25
  );

  @override
  Widget build(BuildContext context) {

    return Consumer<CustomPresetNotifier>(
        builder: (context, CustomPresetNotifier, child) {
        return CustomPresetNotifier.listView;
        }
        );


/*     ListView.builder(
        itemCount: widgetList.length,
        itemBuilder: (context, index) {
          return widgetList[index];
        });*/
  }

/*  List buildWidgetList (){
    List<Widget> widgetList = [];

    widgetList.add(Consumer<CustomPresetNotifier>(builder: (context, CustomPresetNotifier, child) => Text('${CustomPresetNotifier.a}')));

    widgetList = addCompetitionPresets(widgetList);
    widgetList = addCustomPresets(widgetList);
    widgetList.add(AddNewPresetButton());
    return widgetList;
  }


  List<Widget> addCompetitionPresets(List<Widget> widgetList){
    widgetList.add(Text(
      'Competition Presets',
      style: titleStyle,
      textAlign: TextAlign.center,
    ));

    for(int i = 0 ; i < CompPresets.length; i++ ) {
      widgetList.add(PresetAccordion(settings: CompPresets[i]));
    }

    return widgetList;
  }




  List<Widget> addCustomPresets(List<Widget> widgetList){
    widgetList.add(Text(
      'Custom Presets',
      style: titleStyle,
      textAlign: TextAlign.center,
    ));

    Box<Map> customPresets = Hive.box(savedPresets);
    var keys = customPresets.keys;
    for(var key in keys) {
      Map? settings = customPresets.get(key);
      if (settings == null) {
        widgetList.add(Text('ERROR: could not load custom preset'));
      }
      else {
        widgetList.add(PresetAccordion(settings: settings));
      }
    }
    return widgetList;
  }*/
}
