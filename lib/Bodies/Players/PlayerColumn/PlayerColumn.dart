import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'NewNameDialog/AddNameDialog.dart';

class PlayerColumn extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _PlayerColumn();}
}


class _PlayerColumn extends State<PlayerColumn> {
  List<String?> selectedNames = [null, null, null, null];
  List<String> savedPlayerNames = ['David', 'Chris', 'Sarah'];

  static const String ADD_NEW = 'Add Name';
  static const String DESELECT = 'Deselect';
  static const String DELETE_ALL = 'DELETE ALL';


  List<DropdownMenuItem<String>> buildChoiceList(){
    List<DropdownMenuItem<String>> choicesList = [];
    for (int i = 0; i < savedPlayerNames.length; i++){
      choicesList.add(
          DropdownMenuItem(
            value: savedPlayerNames[i],
            child: Text(savedPlayerNames[i]),
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
  List<Container> buildDropDownButtonList(List<DropdownMenuItem<String>> choiceList){
    List<Container> buttonList = [];
    for (int i = 0; i < 4; i++){
      buttonList.add(
        Container(
          padding: EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 10,),
          child: DropdownButton(
            hint: Text('Player #' + i.toString()),
            items: choiceList,
            value: selectedNames[i],
            isExpanded: true,
            onChanged: (selectedName) {parseSelection(selectedName.toString(), i);},
          ),
        )
      );
    }
    return buttonList;
  }
  void parseSelection(String selectedName, int playerNum){
    String? setVal;
    if (selectedName == DESELECT){
      setVal = null;
    }
    else if (selectedName == ADD_NEW) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddNameDialog(addName: updateNameFunc, playerNum: playerNum);
          }
      );
    }
    else if (selectedName == DELETE_ALL){
      selectedNames = [null, null, null, null];
      savedPlayerNames = [];
      setVal = null;
    }
    else {
      setVal = selectedName;
    }
    setState((){selectedNames[playerNum] = setVal;});
  }
  void updateNameFunc(String newName, int playerNum){
    setState(() {
      savedPlayerNames.add(newName);
      selectedNames[playerNum] = newName;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> choiceList = buildChoiceList();
    List<Container> buttonList = buildDropDownButtonList(choiceList);

    return Column(children: buttonList);
  }
}