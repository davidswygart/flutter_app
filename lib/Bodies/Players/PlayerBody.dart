import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bodies/GameMode/CompetitionSettings.dart';

import 'PlayerColumn/PlayerColumn.dart';


class PlayerBody extends StatefulWidget {
  final Preset preset;
  const PlayerBody({required this.preset, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerBody(preset: preset);
  }
}

class _PlayerBody extends State<PlayerBody> {
  Preset preset;
  late bool moveON;
  late bool lTimeoutON;
  late bool rTimeoutON;

  _PlayerBody({required this.preset}) {
    moveON = preset.moveSpeed > 0;
    rTimeoutON = preset.roundTimeout > 0;
    lTimeoutON = preset.lightTimeout > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5),
      child: PlayerColumn(),
    );
  }
}