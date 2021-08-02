// stateless widgets
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ThemeSelection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'タマリバ',
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
      home: Scaffold(body: (MyHomePage(title: 'テーマを選んでね！'))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // firestoreからitemを取得
  final Stream<QuerySnapshot<Map<String, dynamic>>> _themeListStream =
      FirebaseFirestore.instance.collection('Theme').snapshots();

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _themeListStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('error:${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return new ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return new ListTile(
                          title: new Text(data['template']),
                          
                        );
                      }).toList(),
                    );
                  })
            ],
          );
        },
      ),
    );

    // return new ListView(
    //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
    //     Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    //     return new ListTile(
    //       title: new Text(data['template']),
    //     );
    //   }).toList(),
    // );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(widget.title),
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Text('テーマを選んでね！',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                   fontSize: 25,
  //                   fontFamily: 'Poppins',
  //                   fontWeight: FontWeight.bold)),
  //           TextButton(
  //             onPressed: () => {_shareTwitter("課題を一緒にしませんか？？")},
  //             child: Container(
  //               margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
  //               padding: const EdgeInsets.all(5.0),
  //               decoration: BoxDecoration(
  //                 border: Border.all(color: Colors.blue),
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: Container(
  //                 child: const Text("課題をする"),
  //               ),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () => {_shareTwitter("遊びに行きませんか？⚾😆")},
  //             child: Container(
  //               margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
  //               padding: const EdgeInsets.all(5.0),
  //               decoration: BoxDecoration(
  //                 border: Border.all(color: Colors.blue),
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: Container(
  //                 child: const Text("遊びに行く"),
  //               ),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () => {_shareTwitter("ご飯行きませんか？🍜")},
  //             child: Container(
  //               margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
  //               padding: const EdgeInsets.all(5.0),
  //               decoration: BoxDecoration(
  //                 border: Border.all(color: Colors.blue),
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: Container(
  //                 child: const Text("食事する"),
  //               ),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               await Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => ThemeSelection(),
  //                   ));
  //             },
  //             child: Container(
  //               margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
  //               padding: const EdgeInsets.all(5.0),
  //               decoration: BoxDecoration(
  //                 border: Border.all(color: Colors.blue),
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: Container(
  //                 child: const Text("Navigate ThemeSelection"),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
