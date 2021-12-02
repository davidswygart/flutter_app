import 'package:flutter/material.dart';


class BtDevicesBody extends StatefulWidget {
  BtDevicesBody({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _BtDevicesBody();
  }

}

class _BtDevicesBody extends State<BtDevicesBody>{
  TextStyle _titleStyle = TextStyle(fontWeight: FontWeight.bold);

  @override
  void initState() {
    /*BlueDevice.flutterBlue.scan();
    debugPrint('__________The scan was started___');*/
    super.initState();
  }

  @override
  void dispose() {
    /*BlueDevice.flutterBlue.stopScan();
    debugPrint('__________The scan was stopped___');*/
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('Name', style: _titleStyle,),
          trailing: Text('Signal Strength (db)', style: _titleStyle,),
          dense: true,
        ),
        /*StreamBuilder<List<ScanResult>>(
          stream: BlueDevice.getEternalScanResults(),
          initialData: [],
          builder: (BuildContext context, AsyncSnapshot<List<ScanResult>> snapshot){
            List<ScanResult> scanList = [];
            if (snapshot.hasData && !snapshot.hasError){
              scanList = snapshot.data ?? [];
            }
            return Expanded (
              child: ListView.builder(
                itemCount: scanList.length,
                  itemBuilder: (BuildContext context, int index) {

                    String title;
                    if (scanList[index].device.name.isNotEmpty){
                      title = scanList[index].device.name;
                    } else {
                      title = scanList[index].device.id.toString();
                    }

                    scanList.sort((a, b) => b.rssi.compareTo(a.rssi));

                    return ListTile(
                      title: Text(title),
                      trailing: Text(scanList[index].rssi.toString()),
                    );
                    },
              ),
            );
          },),*/
      ],
    );
  }
}
