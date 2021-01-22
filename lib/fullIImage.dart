import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'global.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class FullImage extends StatefulWidget {
  @override
  _FullImageState createState() => _FullImageState();
}

class _FullImageState extends State<FullImage> {
  PageController pageController = PageController(initialPage: Global.index);
  final Dio _dio = Dio();
  String _progress = "";

  void startForegroundService() async {
    await FlutterForegroundPlugin.setServiceMethodInterval(seconds: 5);
    await FlutterForegroundPlugin.setServiceMethod(globalForegroundService);
    await FlutterForegroundPlugin.startForegroundService(
      holdWakeLock: false,
      onStarted: () {
        print("Foreground on Started");
      },
      onStopped: () {
        print("Foreground on Stopped");
      },
      title: "Flutter Foreground Service",
      content: "This is Content",
      iconName: "ic_stat_hot_tub",
    );
  }

  void globalForegroundService() {
    debugPrint("current datetime is ${DateTime.now()}");
  }

  Future<void> _startDownload(String savePath, String fileUrl) async {
    startForegroundService();

    final response = await _dio.download(fileUrl, savePath, onReceiveProgress: _onReceiveProgress);
  }

  Future<bool> _checkPermission() async {
    var storagePermission = await Permission.storage.request();

    return await Permission.storage.isGranted;
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(
        () {
          int percentage = (received / total * 100).ceil();

          if (percentage >= 100) {
            _progress = "Duvar Kağıdı Ayarlanıyor";
          } else {
            _progress = "İndiriliyor (" + percentage.toStringAsFixed(0) + "%)";
          }
        },
      );
    }
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }
    if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }

    throw Exception('Unsupported platform');
  }

  @override
  Widget build(BuildContext context) {
    String btnSetWallpaperText = _progress == "" ? "Duvar Kağıdı Ayarla" : _progress;
    Widget btnSetWallpaperIcon = _progress == ""
        ? Icon(Icons.image_outlined)
        : SizedBox(
            child: CircularProgressIndicator(),
            height: 20,
            width: 20,
          );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Wallpapers'),
        elevation: 5.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PageView.builder(
          controller: pageController,
          itemCount: Global.images.length,
          itemBuilder: (context, index) {
            return Hero(
              tag: '$index',
              child: Container(
                child: ListView(
                  children: [
                    Image.network(
                      Global.images[index].original_url,
                      fit: BoxFit.cover,
                      loadingBuilder:
                          (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                    Divider(
                      height: 10,
                      thickness: 0,
                      color: Colors.transparent,
                    ),
                    RaisedButton.icon(
                      icon: btnSetWallpaperIcon,
                      label: Text(btnSetWallpaperText),
                      onPressed: () async {
                        try {
                          bool permissionGranted = await _checkPermission();

                          if (permissionGranted) {
                            String fileUrl = Global.images[index].original_url;
                            String fileName = Global.images[index].file_name;
                            String downloadDir = (await _getDownloadDirectory()).path;
                            String savePath = downloadDir + '/' + fileName;

                            await _startDownload(savePath, fileUrl);

                            int location = WallpaperManager
                                .HOME_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
                            final String result =
                                await WallpaperManager.setWallpaperFromFile(savePath, location);

                            Global.showSnackBar(context, "Duvar kağıdı ayarlandı.");
                            setState(() {
                              _progress = "";
                            });
                          } else {
                            Global.showSnackBar(context, "Yetki vermeniz gerekmektedir.");
                          }
                        } on PlatformException catch (error) {
                          print(error);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
