import 'package:flutter/material.dart';
import 'package:flutter_app/Bodies/GameMode/CompetitionSettings.dart';

import 'NewGame.dart';


class ActiveBody extends StatefulWidget {
  final Preset preset;
  const ActiveBody({required this.preset, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState(){
    return _ActiveBody(preset: preset);
  }
}

class _ActiveBody extends State<ActiveBody> {
  final Preset preset;
  _ActiveBody({required this.preset});
  NewGame game = NewGame();

  @override
  void initState() {
    super.initState();
    game.play();
  }


  @override
  Widget build(BuildContext context) {
      return StreamBuilder<Widget>(
          stream: game.targetState.stream,
          initialData: Text("Initial Data from Stream Builder"),
          builder: (context, snapshot){
            return snapshot.data ?? Text("Error: Null Data from Stream");
          },
      );
  }
}
