import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'models/image.dart' as ImageModel;

class Global {
  static List<ImageModel.Image> images = new List();
  static int index = 0;

  static void showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      //backgroundColor: Colors.blue[900],
      //textColor: Colors.white,
      fontSize: 12.0,
    );
  }

  static void showSnackBar(BuildContext context, String text) async {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
