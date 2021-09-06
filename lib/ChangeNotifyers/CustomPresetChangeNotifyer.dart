

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/Bodies/Presets/Accordions/PresetAccordion.dart';
import 'package:flutter_app/Bodies/Presets/AddPresetButton/AddPresetButton.dart';
import 'package:flutter_app/Bodies/Presets/CompetitionSettings.dart';
import 'package:hive/hive.dart';

import '../main.dart';

class CustomPresetNotifier extends ChangeNotifier {
  CustomPresetNotifier(){buildListView();}
  List widgetList = [];
  ListView listView = ListView();

  void buildListView(){
    buildWidgetList();

    listView = ListView.builder(
        itemCount: widgetList.length,
        itemBuilder: (context, index) {
          return widgetList[index];
        }
    );
  }

  void buildWidgetList(){
    widgetList = [];
    addCompetitionPresets();
    addCustomPresets();
    widgetList.add(AddNewPresetButton());
  }

  void addCompetitionPresets(){
    widgetList.add(Text(
      'Competition Presets',
      style: titleStyle,
      textAlign: TextAlign.center,
    ));
    for(int i = 0 ; i < CompPresets.length; i++ ) {
      widgetList.add(PresetAccordion(settings: CompPresets[i]));
    }
  }

  void addCustomPresets(){
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
  }




  void add(Map settings) {
    Box<Map> presetBox = Hive.box(savedPresets);
    var now = DateTime.now();
    int key = now.second;
    settings['key'] = key;
    presetBox.put(key, settings);
    buildListView();
    notifyListeners();
  }

  void deleteAll() {
    Box<Map> presetBox = Hive.box(savedPresets);
    for (var key in presetBox.keys) {
      presetBox.delete(key);
    }
    buildListView();
    notifyListeners();
  }









  static const TextStyle titleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 25
  );
}
