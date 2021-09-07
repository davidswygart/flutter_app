import 'package:flutter/material.dart';

class DelayBetweenRounds{
  late final DataRow dataRow;
  final BuildContext context;
  final Map settings;
  DelayBetweenRounds(this.settings, this.context){
    dataRow = DataRow(
      cells: <DataCell>[
        DataCell(Text('Delay between Rounds')),
        DataCell(Text(settings['Delay between Rounds'].toString() + ' s'),
          showEditIcon: settings['editable'],
          onTap:(){showNewPresetDialog();}
        ),
      ],
    );
  }


  showNewPresetDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DelayBetweenRoundsDialog(settings: settings);}
    );
  }
}

class DelayBetweenRoundsDialog extends StatefulWidget{
  final Map settings;
  double val = 0;
  DelayBetweenRoundsDialog({required this.settings}){
    //this.settings = settings;
    int intVal = settings['Delay between Rounds'];
    val = intVal.toDouble();
  }


  @override
  State<StatefulWidget> createState() => _DelayBetweenRoundsDialog();
}

class _DelayBetweenRoundsDialog extends State<DelayBetweenRoundsDialog>{

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        children: <Widget>[
          Text('Delay Between Rounds',
            textAlign: TextAlign.center,
            textScaleFactor: 1.3,
          ),
          Text('Delay in seconds between each round.',
            textAlign: TextAlign.center,
            textScaleFactor: 1,
          ),
          Slider(
            value: widget.val,
            label: widget.val.toStringAsFixed(1),
            onChanged: (double newVal) {
              setState(() => widget.val = newVal );
            },
            min: 0,
            max: 30,
            divisions: 240,
          ),

          Padding(
            padding: EdgeInsets.only(left:10, right:10),
            child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: widget.val.toStringAsFixed(2),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Value',
                ),
                onSubmitted: (String newValString) {
                  double newVal = double.parse(newValString);
                  setState(() => widget.val = newVal );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            ElevatedButton(
              onPressed: () {},
              child: const Text('Cancel',
                textScaleFactor: 1.3,
              ),
              style: ElevatedButton.styleFrom(primary: Colors.red,)
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Submit',
                textScaleFactor: 1.3,
              ),
              style: ElevatedButton.styleFrom(primary: Colors.green,)
            )
          ],
          )
        ]);
  }
}
