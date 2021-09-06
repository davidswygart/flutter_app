import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';

import 'DeleteRenameNotification/DeleteRenameDiolog.dart';

class AccordionTitle extends StatelessWidget{
  final String title;
  AccordionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Text(title,
          style: TextStyle(
            //backgroundColor: Colors.red,
          )
        ),
        onLongPress: (){showDeleteRenameDialog(context);}
    );
  }

  showDeleteRenameDialog(context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteRenameDialog();
        }
    );
  }
}