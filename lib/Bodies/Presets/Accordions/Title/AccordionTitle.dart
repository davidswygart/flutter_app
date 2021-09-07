import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';

import 'DeleteRenameNotification/CopyCompDialog.dart';
import 'DeleteRenameNotification/DeleteRenameDiolog.dart';

class AccordionTitle extends StatelessWidget{
  final Map settings;
  AccordionTitle({required this.settings});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Text(settings['title'],
          style: TextStyle(
            //backgroundColor: Colors.red,
          )
        ),
        onLongPress: (){showDeleteRenameDialog(context, settings);}
    );
  }

  showDeleteRenameDialog(context, settings) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (settings['editable']) {
            return DeleteRenameDialog(settings: settings,);
          }
          else {
            return CopyCompDialog(settings: settings,);
          }
        }
    );
  }
}