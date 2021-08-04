import 'package:flutter/material.dart';
import 'package:hello_world/page/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventListPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EventListPage> {
  final Stream<QuerySnapshot<Map<String, dynamic>>> _eventListStream =
      FirebaseFirestore.instance.collection('event').snapshots();

  Widget _messageItem(String title, String eventId) {
    return Container(
      decoration: new BoxDecoration(
          border:
              new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        onTap: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventPage(
                  eventId: eventId,
                ),
              ));
        },
      ),
    );
  }

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
            title: _messageItem('${data['title']}', document.id),
          );
        }).toList());
      },
    );
  }
}
