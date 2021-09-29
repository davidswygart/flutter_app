import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

class ColorRow extends StatefulWidget {
  final List<String> labels;
  ColorRow({required this.labels});

  @override
  State<StatefulWidget> createState() {
    return _ColorRow();
  }
}

class _ColorRow extends State<ColorRow> {
  List<Color> colorList = [
    Colors.green.shade800,
    Colors.blue.shade800,
    Colors.red.shade800,
    Colors.yellow.shade500,
  ];
  late List<Container> dragList;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    dragList = List<Container>.generate(
        4,
        (int index) => Container(
              key: ValueKey(index),
              width: screenWidth / 5,
              height: screenWidth / 5,
              padding: EdgeInsets.all(5),
              child: Container(
                alignment: Alignment.center,
                child: Text(widget.labels[index]),
                color: colorList[index],
              ),
            ));

    return Container(
      alignment: Alignment.topCenter,
      child: ReorderableRow(
        //buildDraggableFeedback: (BuildContext c,BoxConstraints b, Widget w){},
        ignorePrimaryScrollController: true,
        needsLongPressDraggable: false,
        padding: EdgeInsets.all(5),
        children: dragList,
        onReorder: (int oldIndex, int newIndex) {
          Color c = colorList.removeAt(oldIndex);
          colorList.insert(newIndex, c);
          setState(() {});
        },
      ),
    );
  }
}
