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

// date: 日時リスト
// event: イベント詳細
class Props {
  Props({required this.event, required this.date});

  DocumentSnapshot<Object?> event;
  QuerySnapshot<Map<String, dynamic>> date;
}

Future<Props>? initialProps(
    CollectionReference eventList, String eventId) async {
  DocumentReference<Object?> eventRef = eventList.doc(eventId);

  DocumentSnapshot<Object?> event = await eventRef.get();
  QuerySnapshot<Map<String, dynamic>> date =
      await eventRef.collection('optionList').get();

  return Props(date: date, event: event);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({required this.eventId}) : super();

  final String eventId;

  CollectionReference eventList =
      FirebaseFirestore.instance.collection('event');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Props>(
      future: initialProps(eventList, eventId),
      builder: (BuildContext context, AsyncSnapshot<Props> snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        if (snapshot.hasData && !snapshot.data!.event.exists) {
          return Text("Event does not exist");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              semanticsLabel: 'Linear progress indicator',
            ),
          );
        }

        Map<String, dynamic> eventData =
            snapshot.data!.event.data() as Map<String, dynamic>;

        List<QueryDocumentSnapshot<Map<String, dynamic>>> dateData =
            snapshot.data!.date.docs;

        bool _flag = false;

        void _handleCheckbox(bool? e) {
          setState(() {
            _flag = true;
          });
        }

        return Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              Column(
                children: <Widget>[
                  Text(eventData["title"]),
                  Text(eventData["username"]),
                  Column(
                    children: dateData
                        .map<Widget>((e) => new CheckboxListTile(
                              title: Text('${e.data()["option"]}'),
                              subtitle: Text('${e.data()["reaction"]}'),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _flag,
                              onChanged: _handleCheckbox,
                            ))
                        .toList(),
                  )
                ],
              ),
            ]));
      },
    );
  }
}
