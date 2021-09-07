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
            Container(
              child: Text('Last Game results'),
              color: Colors.lightBlueAccent,
              padding: EdgeInsets.all(100),
              margin: EdgeInsets.all(20),
            ),
            Container(
              child: Text('graph of scores over time or histogram comparing you to others'),
              color: Colors.lightGreen,
              padding: EdgeInsets.all(100),
              margin: EdgeInsets.all(20),
            ),
            ElevatedButton(
              onPressed: () {Navigator.pushNamed(context,'/GameModes');},
              child: const Text('Start New Game',
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