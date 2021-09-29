import 'package:flutter/material.dart';

class PaddleDisplay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PaddleDisplay();
  }
}

class _PaddleDisplay extends State<PaddleDisplay> {
  Map<String, Color> colorsOptions = {
    'Red': Colors.red.shade500,
    'Green': Colors.green.shade500,
    'Blue': Colors.blue.shade500,
    'White': Colors.white,
    'default': Colors.grey.shade500
  };

  late List<String?> currentColor;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    List<Widget> paddleList = buildPaddleList(screenWidth);

    return Row(
      children: paddleList,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }

  List<Widget> buildPaddleList(double screenWidth) {
    List<Container> paddleList = [];

    for (int i = 0; i < 4; i++) {
      paddleList.add(
        Container(
          padding: EdgeInsets.all(10),
          width: screenWidth / 4,
          height: screenWidth / 4,
          child: Container(
            color: colorsOptions.values.elementAt(i),
            alignment: Alignment.center,
            child: Text(
              (i + 1).toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return paddleList;
  }
}
