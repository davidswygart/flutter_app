import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/AppBar/BlueToothBar.dart';

class PlayersPage extends StatelessWidget {
  const PlayersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BlueToothBar(title: 'Choose Players',),
      body: PlayerBody(),
    );
  }
}

class PlayerBody extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _PlayerBody();}
}

class _PlayerBody extends State<PlayerBody>{
  @override
  Widget build(BuildContext context) {
    return Column(

    );
  }
}