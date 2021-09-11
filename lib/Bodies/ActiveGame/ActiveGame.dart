

import 'package:flutter/material.dart';
import 'package:flutter_app/AppBar/BlueToothBar.dart';

import 'PaddleDisplay.dart';

class ActiveGamePage extends StatelessWidget {
  const ActiveGamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BlueToothBar(title: 'Play Game',),
      body: ActiveBody(),
    );
  }
}

class ActiveBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ActiveBody();}
}

class _ActiveBody extends State<ActiveBody> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PaddleDisplay(),
        Text('Shoot Your Color!', textScaleFactor: 3,),
        ElevatedButton(
          onPressed: () {Navigator.pushNamed(context,'/Dashboard');},
          child: const Text('Quit Game',
            style: TextStyle(
                fontSize:20
            ),
          ),
        ),
      ],
    );
  }
}