

import 'package:flutter/material.dart';

class ActiveGamePage extends StatefulWidget {
  const ActiveGamePage({Key? key}) : super(key: key);

  @override
  State<ActiveGamePage> createState() => _ActiveGamePage();
}

class _ActiveGamePage extends State<ActiveGamePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: StreamBuilder(
        // stream: game.streamController.stream,
        // builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {},
        // )
    );
  }
}