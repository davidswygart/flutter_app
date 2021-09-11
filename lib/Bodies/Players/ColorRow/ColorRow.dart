import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

class ColorRow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ColorRow();}
}

class _ColorRow extends State<ColorRow> {
  List<Color> colorList = [
    Colors.green.shade800,
    Colors.blue.shade800,
    Colors.red.shade800,
    Colors.yellow.shade500,
  ];

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      Color row = colorList.removeAt(oldIndex);
      colorList.insert(newIndex, row);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    List<Container> dragTiles = [];
    for (int i=0; i<4; i++){
      dragTiles.add(
        Container(
          padding: EdgeInsets.all(10),
          key: ValueKey(i),
          width: screenWidth/4,
          height: screenWidth/4,
          //color: Colors.green.shade300,
          child: Container(color: colorList[i],),
        ),
      );
    }

    List<Container> labelTiles = [];
    for (int i=0; i<4; i++){
      labelTiles.add(
        Container(
          padding: EdgeInsets.all(10),
          key: ValueKey(i),
          width: screenWidth/4,
          height: screenWidth/4,
          alignment: Alignment.center,
          //color: Colors.green.shade300,
          child: Text((i+1).toString(), textScaleFactor: 1.5,),
        ),
      );
    }


    return Stack(
      children: [
        Row(
            children: labelTiles,
          ),
        Opacity(
          opacity: .6,
          child: ReorderableRow(
            mainAxisAlignment: MainAxisAlignment.end,
            needsLongPressDraggable: false,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: dragTiles,
            onReorder: _onReorder,
          ),
        ),
      ],
    );
  }
}
