import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'models/image.dart' as ImageModel;

class Global {
  static List<ImageModel.Image> images = new List();
  static int index = 0;

  static void showToast(String text) {
    Fluttertoast.showToast(
      msg: "This is Center Short Toast",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
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
