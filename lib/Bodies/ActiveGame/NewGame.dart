import 'dart:async';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/BlueTooth/BluetoothObjects.dart';
import 'package:flutter_app/BlueTooth/ConnectHandler.dart';

import 'package:flutter_blue/flutter_blue.dart';



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
    await hitPadChar!.setNotifyValue(true); //TODO move this to an earlier location
    const List<int> goColor = [0, 200, 0];
    const List<int> noGoColor = [200, 0, 0];
    const List<int> blankColor = [0,0,0];
    const int rndDelayMax = 5000; // ms
    const int timeout = 5000; //ms
    Random rng = Random();
    int previousReactionTime = 1000; //This gets used for no-go trials before go
    int scoreMultiplier = 1;
    num totalScore = 0;


    targetState.add(Text("Get Ready", textScaleFactor: 3,));
    await new Future.delayed(const Duration(seconds : 4));
    targetState.add(Text("3", textScaleFactor: 3,));
    await new Future.delayed(const Duration(seconds : 1));
    targetState.add(Text("2", textScaleFactor: 3,));
    await new Future.delayed(const Duration(seconds : 1));
    targetState.add(Text("1", textScaleFactor: 3,));

    for (int rnd = 0; rnd < 10; rnd++){
      await new Future.delayed(Duration(milliseconds : rng.nextInt(rndDelayMax))); //Round Delay
      // create the epoch

      bool go = rng.nextBool();
      if (go){await padColChar!.write(goColor);}
      else {await padColChar!.write(noGoColor);}

      //targetState.add(PaddleDisplay(lstCols: [Colors.red.shade500, Colors.green.shade500, Colors.blue.shade500, Colors.blue.shade500]));

      //Wait for a response
      new Future.delayed(const Duration(milliseconds : timeout), (){
        loopControl.add([-1]);
        debugPrint("Timeout");
      }); // value of -1 means that timeout was reached
      List<int> h = await loopControl.stream.firstWhere((val) => val.isNotEmpty);
      debugPrint(h.toString());
      //List<int> h = await hitPadChar!.value.firstWhere((val) => val.isNotEmpty);

      int reactionTime;
      if (h[0] == -1){
        debugPrint("Timeout");
        reactionTime = -1;
      }
      else{
        reactionTime = ByteData.sublistView(Uint8List.fromList(h)).getUint32(0, Endian.little);
        previousReactionTime = reactionTime;
        debugPrint("reaction Time = " + reactionTime.toString());
      }


      int penalty;
      String message;

      if (go & (reactionTime > 0)){
        message = "Correct Go";
        penalty = reactionTime;
        scoreMultiplier *= 2;
      }
      else if(go & (reactionTime == -1)){
        message ="Timeout on Go";
        penalty = timeout;
        scoreMultiplier = 1;
      }
      else if(!go & (reactionTime > 0)){
        message = "Shouldn't have gone";
        penalty = timeout;
        scoreMultiplier = 1;
      }
      else if(!go & (reactionTime == -1)){
        message = "Correct No-Go";
        penalty = previousReactionTime;
        scoreMultiplier *= 2;
      }
      else{
        targetState.add(Text("Error: reaction time = "+ reactionTime.toString(), textScaleFactor: 3,));
        message = "Error determining if hit was justified";
        penalty = 1;
        scoreMultiplier = scoreMultiplier;
      }


      double roundScore = scoreMultiplier*1000/penalty;
      totalScore += roundScore;

      targetState.add(Column(children: [
        Text(message),
        Text("reaction time = " + reactionTime.toString(), textScaleFactor: 3,),
        Text("round score = " + roundScore.toString(), textScaleFactor: 3,),
        Text("total score = " + totalScore.toString(), textScaleFactor: 3,),
      ],
      )
      );

      await padColChar!.write(blankColor);
    }
    await new Future.delayed(Duration(seconds : 5));
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
