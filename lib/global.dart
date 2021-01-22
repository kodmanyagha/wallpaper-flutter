import 'package:flutter/material.dart';

import 'models/image.dart' as ImageModel;

class Global {
  static List<ImageModel.Image> images = new List();
  static int index = 0;

  static void showSnackBar(BuildContext context, String text) async {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
