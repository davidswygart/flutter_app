import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/BlueTooth/BluetoothObjects.dart';
import 'package:flutter_app/BlueTooth/ConnectHandler.dart';
import 'package:flutter_app/Bodies/GameMode/CompetitionSettings.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:math';
import 'dart:convert';

import 'PaddleDisplay.dart';


class NewGame {
  BluetoothCharacteristic? padColChar;
  BluetoothCharacteristic? hitPadChar;
  StreamController<Widget> targetState = StreamController<Widget>.broadcast();
  StreamController<List<int>> loopControl = StreamController<List<int>>.broadcast();

  NewGame() {
    //TODO Send general game settings to ESP32
    BlueToothObjects btObj = ConnectHandler.getBtObjects();
    padColChar = btObj.getChar('Play', 'paddleColor');
    hitPadChar = btObj.getChar('Play', 'hitPaddle');
    if (padColChar == null) {throw ('characteristic is null');}
    hitPadChar!.value.listen((val){loopControl.add(val);});
  }

  Future<void> play() async {
    targetState.add(Text("Get Ready", textScaleFactor: 3,));
    await new Future.delayed(const Duration(seconds : 4));
    targetState.add(Text("3", textScaleFactor: 3,));
    await new Future.delayed(const Duration(seconds : 1));
    targetState.add(Text("2", textScaleFactor: 3,));
    await new Future.delayed(const Duration(seconds : 1));
    targetState.add(Text("1", textScaleFactor: 3,));

    List<List<int>> colorOptions = [[0, 200, 0], [200, 0, 0], [0, 0, 200]];
    Random rng = Random();

    for (int rnd = 0; rnd < 10; rnd++){
      await new Future.delayed(Duration(seconds : 5));
      // create the epoch

      int i = rng.nextInt(2);
      //send the epoch;
      await padColChar!.write(colorOptions[i] + [0,0,0] + [0,0,0] + [0,0,0]);
      targetState.add(PaddleDisplay(lstCols: [Colors.red.shade500, Colors.green.shade500, Colors.blue.shade500, Colors.blue.shade500]));

      //Wait for a response
      await hitPadChar!.setNotifyValue(true); //TODO move this to an earlier location

      new Future.delayed(const Duration(seconds : 1), (){loopControl.add([-100]);}); // value of -100 means that timeout was reached
      List<int> h = await hitPadChar!.value.firstWhere((val) => val.isNotEmpty);
      List<int> reactionTime = Uint8List.fromList(h.sublist(1));
      utf8.decode([1,1,1,1,1]);

      if (i==0 && h[0]==0 || i>0 && h[0]==1){
        targetState.add(Text("Good Job"+ reactionTime.toString(), textScaleFactor: 3,));
      }
      else{
        targetState.add(Text("WRONG!!!"+ reactionTime.toString(), textScaleFactor: 3,));
      }
    }
    targetState.add(Text("End of game", textScaleFactor: 3,));
  }
}


/*
for (int rnd = 0; rnd < 10; rnd++){
      await new Future.delayed(const Duration(seconds : 1));
      // create the epoch
      List<List<int>> pColors = [[200, 200, 200], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
      List<int> playerNum = [0,1,2,3];
      playerNum.shuffle();


      List<int> epoch = [];
      for (int i = 0; i<4; i++){
        epoch = epoch + pColors[playerNum[i]];
      }

      //send the epoch;
      await padColChar!.write(epoch);
      targetState.add(PaddleDisplay(lstCols: [Colors.red.shade500, Colors.green.shade500, Colors.blue.shade500]));

      //Wait for a response
      await hitPadChar!.setNotifyValue(true);

      List<int> h = await hitPadChar!.value.firstWhere((val) => val.isNotEmpty);

      targetState.add(Text("Get Ready", textScaleFactor: 3,));
      int hitTarget = h[0];
      playerNum[hitTarget] == 0

      List<int> reactionTimeLst = Uint32List.fromList(h.sublist(1));
      int reactionTime = reactionTimeLst[0];



      List displayInfo = ["hitInfo", "player 1", ];
      targetState.add("hit target! Reaction Time = " + reactionTime.toString());

      await new Future.delayed(const Duration(seconds : 1));
    }
*/
