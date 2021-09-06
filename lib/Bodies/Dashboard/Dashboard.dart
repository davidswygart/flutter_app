import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../AppBar/BlueToothBar.dart';

class DashPage extends StatelessWidget {
  const DashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BlueToothBar(title: 'HTT Dashboard',),
      body: const DashBody(),
    );
  }
}

class DashBody extends StatelessWidget {
  const DashBody({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {Navigator.pushNamed(context,'/GameModes');},
              child: const Text('Start Game',
                style: TextStyle(
                  fontSize:20
                ),
              ),
        ),
      ],
    )
    );
  }
}