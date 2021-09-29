import 'package:flutter/material.dart';

class AdvanceButton extends StatelessWidget {
  final String text;
  final String route;
  const AdvanceButton({Key? key, required this.text, required this.route})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      constraints: BoxConstraints.expand(width: width / 2, height: width / 8),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
              ),
              Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }
}
