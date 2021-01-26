import 'dart:convert';

import 'global.dart';
import 'models/image.dart' as ImageModel;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  getWallpaper() async {
    await http.get('${env['BASE_API']}/random?limit=60').then((res) {
      print(res.body);
      var parsedJson = jsonDecode(res.body);
      Global.images =
          (parsedJson["data"]["images"] as List).map((data) => ImageModel.Image.fromJson(data)).toList();
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getWallpaper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Duvar Kağıdı'),
        elevation: 5.0,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).pushNamed('SearchBar');
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: GridView.builder(
          itemCount: Global.images.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5, childAspectRatio: 0.8),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Global.index = index;
                Navigator.of(context).pushNamed('imageDetails');
              },
              child: Hero(
                tag: '$index',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      image: NetworkImage(
                        Global.images[index].tiny_url,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'DUVAR KAĞIDI DEĞİŞTİRİCİ',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/drawerHeader.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              title: Text('Anasayfa'),
              leading: Icon(Icons.dashboard),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Kategoriler'),
              leading: Icon(Icons.category_rounded),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              title: Text('Ayarlar'),
              leading: Icon(Icons.settings),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Öneri / Şikayet'),
              leading: Icon(Icons.chat_outlined),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Uygulama Bilgileri'),
              leading: Icon(Icons.info_rounded),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
