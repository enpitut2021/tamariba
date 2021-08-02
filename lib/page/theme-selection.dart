// final dummyTheme = [
//   {"themeId": 1, "theme": "課題をしよう", "template": "課題をしよう!"},
//   {"themeId": 2, "theme": "ご飯を行く", "template": "ご飯に行こう"},
//   {"themeId": 3, "theme": "遊びに行く", "template": "遊びに行こう"},
// ];

// stateless widgets
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ThemeSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DocumentSnapshot> documentList = [];

  _getState() async {
    // 指定コレクションのドキュメント一覧を取得
    final snapshot = await FirebaseFirestore.instance
        .collection('test_collection1')
        .snapshots();
    // ドキュメント一覧を配列で格納
    setState(() {
      documentList = snapshot.documents;
    });
  }

  // Twitterに投稿するURLに飛ぶ
  _shareTwitter(String tweetText) async {
    var url = 'https://twitter.com/intent/tweet?text=$tweetText';
    var encodedUrl = Uri.encodeFull(url);

    if (await canLaunch(encodedUrl)) {
      await launch(encodedUrl);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Text('hello'));
  }
}
