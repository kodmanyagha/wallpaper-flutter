import 'package:flutter/material.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:wallpaper_app/fullIImage.dart';
import 'package:wallpaper_app/global.dart';
import 'package:wallpaper_app/home.dart';
import 'package:wallpaper_app/searchBar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DotEnv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  void _startForegroundService() async {
    await FlutterForegroundPlugin.setServiceMethodInterval(seconds: 10);
    await FlutterForegroundPlugin.setServiceMethod(globalForegroundService);
    await FlutterForegroundPlugin.startForegroundService(
      holdWakeLock: false,
      onStarted: () {
        print("Foreground service started");
      },
      onStopped: () {
        print("Foreground service stopped");
      },
      title: "Foreground Service",
      content: "This is Content",
      iconName: "ic_stat_hot_tub",
    );
  }

  static void globalForegroundService() {
    String text = "current datetime is ${DateTime.now()}";
    print(text);
  }

  @override
  Widget build(BuildContext context) {
    _startForegroundService();

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
