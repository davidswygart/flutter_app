import 'package:flutter/material.dart';

class PaddleDisplay extends StatefulWidget {
  List<Color> lstCols;
  PaddleDisplay({required this.lstCols});

  @override
  State<StatefulWidget> createState() {
    return _PaddleDisplay(lstCols: lstCols);
  }
}

class _PaddleDisplay extends State<PaddleDisplay> {
  List<Color> lstCols;
  _PaddleDisplay({required this.lstCols});

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
            color: lstCols[i],
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
