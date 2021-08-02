// final dummyTheme = [
//   {"themeId": 1, "theme": "課題をしよう", "template": "課題をしよう!"},
//   {"themeId": 2, "theme": "ご飯を行く", "template": "ご飯に行こう"},
//   {"themeId": 3, "theme": "遊びに行く", "template": "遊びに行こう"},
// ];

// stateless widgets
import 'package:flutter/material.dart';
import 'package:hello_world/page/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventListPage extends StatelessWidget {
  EventListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'イベント一覧',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(body: (MyHomePage())),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Stream<QuerySnapshot<Map<String, dynamic>>> _eventListStream =
      FirebaseFirestore.instance.collection('event').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _eventListStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('error:${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          // ローディング
          return CircularProgressIndicator(
            semanticsLabel: 'Linear progress indicator',
          );
        }

        return new ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return new ListTile(
              title: new TextButton(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventPage(
                          eventId: document.id,
                        ),
                      ));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    child: Text('${data['title']}'),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
