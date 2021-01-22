import 'package:flutter/material.dart';
import 'package:wallpaper_app/fullIImage.dart';
import 'package:wallpaper_app/home.dart';
import 'package:wallpaper_app/searchBar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() async {
  await DotEnv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      routes: {
        'imageDetails': (context) => FullImage(),
        'search': (context) => SearchBarTool(),
      },
    );
  }
}
