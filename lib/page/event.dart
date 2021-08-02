// stateless widgets
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventPage extends StatelessWidget {
  EventPage({Key? key, required this.eventId}) : super(key: key);

  // firestore/eventのid
  final String eventId;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'イベントページ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          body: (MyHomePage(
        eventId: this.eventId,
      ))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.eventId}) : super(key: key);

  final String eventId;

  @override
  _MyHomePageState createState() => _MyHomePageState(
        eventId: this.eventId,
      );
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({required this.eventId}) : super();

  final String eventId;

  CollectionReference eventList =
      FirebaseFirestore.instance.collection('event');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: eventList.doc(eventId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Event does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text("${data['title']}");
        }

        // ローディング
        return CircularProgressIndicator(
          semanticsLabel: 'Linear progress indicator',
        );
      },
    );
  }
}
