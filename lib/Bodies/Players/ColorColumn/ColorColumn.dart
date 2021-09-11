import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorColumn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ColorColumn();}
}


class _ColorColumn extends State<ColorColumn> {
  static const Map<String, MaterialColor> colorsOptions = {
    'Red': Colors.red,
    'Green': Colors.green,
    'Blue': Colors.blue
    ,'White': Colors.grey};
  List<String?> selectedColor = [null, null, null, null];


  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> choiceList = buildChoiceList();
    List<Container> buttonList = buildButtonList(choiceList);

    return Column(children: buttonList);
  }

  List<DropdownMenuItem<String>> buildChoiceList(){
    List<DropdownMenuItem<String>> choiceList = [];
    for (String key in colorsOptions.keys){
      choiceList.add(
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

    return choiceList;
  }

  List<Container> buildButtonList(List<DropdownMenuItem<String>> colorChoiceList){
    List<Container> buttonList = [];

    for (int i = 0; i < 4; i++){
      buttonList.add(
          Container(
            padding: EdgeInsets.only(left: 5, right: 15, top: 10, bottom: 10,),
            child: DropdownButton(
              hint: Text("color"),
              items: colorChoiceList,
              value: selectedColor[i],
              isExpanded: true,
              onChanged: (newValue) {
                setState((){
                  selectedColor[i] = newValue.toString();
                });
                },
            ),
          )
      );
    }

    return buttonList;
  }
}
