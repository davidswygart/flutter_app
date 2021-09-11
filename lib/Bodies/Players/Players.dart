import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/AppBar/BlueToothBar.dart';
import 'package:flutter_app/Bodies/Players/PlayerColumn/PlayerColumn.dart';

import 'ColorColumn/ColorColumn.dart';
import 'ColorRow/ColorRow.dart';


class PlayersPage extends StatelessWidget {
  const PlayersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BlueToothBar(title: 'Players',),
      body: PlayerBody(),
    );
  }
}

class PlayerBody extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _PlayerBody();}
}

class _PlayerBody extends State<PlayerBody> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text('Choose Players',
              textAlign: TextAlign.center,
              textScaleFactor: 1.8,
            ),
          ),
        Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: screenWidth * .7,
                  //padding: EdgeInsets.all(20),
                  child: PlayerColumn(),
                ),
                Container(
                  width: screenWidth * .3,
                  //padding: EdgeInsets.all(20),
                  child: ColorColumn(),
                ),
              ]
          ),
        ColorRow(),
        Container(
          child: ElevatedButton(
            onPressed: () {Navigator.pushNamed(context,'/ActiveGame');},
            child: const Text('Start Game',
              style: TextStyle(fontSize:20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}