import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';

import 'Body/DataTable.dart';
import 'Title/AccordionTitle.dart';

class PresetAccordion extends StatelessWidget {
  final Map settings;
  PresetAccordion({required this.settings,});

  @override
  Widget build(BuildContext context) {
    return GFAccordion(
      margin: const EdgeInsets.all(1),
      titleChild: AccordionTitle(title: settings['title'],),
      contentChild: SettingsDataTable(settings: settings),
      collapsedIcon: Icon(Icons.arrow_drop_up),
      expandedIcon: Icon(Icons.arrow_drop_down),
    );
  }
}