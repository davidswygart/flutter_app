import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/AppBar/BlueToothBar.dart';

import 'NewNameDialog/AddNameDialog.dart';

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

class _PlayerBody extends State<PlayerBody>{
  List<String?> selectedNames = [null, null, null, null];
  List<String> savedPlayerNames = ['David','Chris','Sarah'];

  Map<String, MaterialColor> colorsOptions = {'Red': Colors.red, 'Green': Colors.green, 'Blue': Colors.blue ,'White': Colors.grey};
  List<String?> selectedColor = [null, null, null, null];

  static const String ADD_NEW = 'Add Name';
  static const String DESELECT = 'Deselect';
  static const String DELETE_ALL = 'DELETE ALL';


  List<Widget> bodyList = [];
  double screenWidth = 100;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    buildBodyList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: bodyList,);
  }

  buildBodyList(){
    bodyList = [
      Container(
        padding: EdgeInsets.symmetric(vertical: 10),
          child: Text('Choose Players',
            textAlign: TextAlign.center,
            textScaleFactor: 1.8,
      )),
    ];

    for (int i = 0; i < 4; i++){
      List<DropdownMenuItem<String>> nameChoiceList = buildNameChoiceList();
      DropdownButton playerDropdown = DropdownButton(
        hint: Text('Player #' + i.toString()),
        items: nameChoiceList,
        value: selectedNames[i],
        isExpanded: true,
        onChanged: (newValue) {
          String? setVal;
          if (newValue.toString() == DESELECT){
            setVal = null;
          }
          else if (newValue.toString() == ADD_NEW) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddNameDialog(addName: addName, playerNum: i);
                }
            );
          }
          else if (newValue.toString() == DELETE_ALL){
            selectedNames = [null, null, null, null];
            savedPlayerNames = [];
            setVal = null;
          }
          else {
            setVal = newValue.toString();
          }
          setState((){selectedNames[i] = setVal;});
        },
      );

      List<DropdownMenuItem<String>> colorChoiceList = buildColorChoiceList();
      DropdownButton colorDropdown = DropdownButton(
        items: colorChoiceList,
        value: selectedColor[i],
        isExpanded: true,
        onChanged: (newValue) {
          setState((){
            selectedColor[i] = (newValue.toString() == '')
                ?null
                :newValue.toString();
          }
          );
        },
      );

      bodyList.add(
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:[
            Container(
                child:playerDropdown,
                width: screenWidth*.7,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10)
            ),
            Container(
                child:colorDropdown,
                width: screenWidth*.3,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
          ]
        ),
      );
    }
  }

  List<DropdownMenuItem<String>> buildNameChoiceList(){
    List<String> availableNames = [...savedPlayerNames];
    List<DropdownMenuItem<String>> choicesList = [];

    for (int i = 0; i < availableNames.length; i++){
      choicesList.add(
          DropdownMenuItem(
            value: availableNames[i],
            child: Text(availableNames[i]),
          )
      );
    }

    choicesList.add(DropdownMenuItem(
      value: ADD_NEW,
      child: Text(ADD_NEW, style: TextStyle(
        fontStyle: FontStyle.italic,
        color: Colors.green,
      )),
    ));

    choicesList.add(DropdownMenuItem(
      value: DESELECT,
      child: Text(DESELECT, style: TextStyle(
        fontStyle: FontStyle.italic,
        color: Colors.deepOrange,
      )),
    ));

    choicesList.add(DropdownMenuItem(
      value: DELETE_ALL,
      child: Text(DELETE_ALL, style: TextStyle(
        fontStyle: FontStyle.italic,
        color: Colors.red,
      )),
    ));

    return choicesList;
  }

  List<DropdownMenuItem<String>> buildColorChoiceList(){
    List<DropdownMenuItem<String>> colorChoiceList = [];

    for (String key in colorsOptions.keys){
      colorChoiceList.add(
          DropdownMenuItem(
            value: key,
            child: Container(
              alignment: Alignment.center,
              color:colorsOptions[key],
              child:Text(key),
              padding: EdgeInsets.all(5),
              ),
          )
      );
    }
    return colorChoiceList;
  }

  void addName(String newName, int playerNum){
    savedPlayerNames.add(newName);
    selectedNames[playerNum] = newName;
    setState(() {});
  }
}


