// stateless widgets
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventPage extends StatefulWidget {
  EventPage({Key? key, required this.eventId}) : super(key: key);

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

  final DocumentSnapshot<Object?> event;
  final QuerySnapshot<Map<String, dynamic>> date;
}

Future<Props> initialProps(
    CollectionReference eventList, String eventId) async {
  DocumentReference<Object?> eventRef = eventList.doc(eventId);

  DocumentSnapshot<Object?> event = await eventRef.get();
  QuerySnapshot<Map<String, dynamic>> date =
      await eventRef.collection('optionList').get();

  return Props(date: date, event: event);
}

class _MyHomePageState extends State<EventPage> {
  _MyHomePageState({required this.eventId}) : super();

  final String eventId;

  CollectionReference eventList =
      FirebaseFirestore.instance.collection('event');

  // state
  List<bool> _dateDataReactionFlag = List.filled(100, false);
  TextEditingController _userName = TextEditingController();

  _onSubmitted() async {
    CollectionReference<Map<String, dynamic>> optionListRef = FirebaseFirestore
        .instance
        .collection('event')
        .doc(eventId)
        .collection('optionList');

    QuerySnapshot optionListSnap = await optionListRef.get();

    optionListSnap.docs.asMap().forEach((i, doc) async {
      DocumentReference target = optionListRef.doc(doc.id);
      Map<String, dynamic> list = doc.data() as Map<String, dynamic>;

      if (_dateDataReactionFlag[i]) {
        target.update({
          'option': list['option'],
          'reaction': list['reaction'] == null
              ? [_userName.text]
              : [...list['reaction'], _userName.text],
        });
      }

      Navigator.of(context)
          .push(new MaterialPageRoute(builder: (BuildContext context) {
        return new EventPage(eventId: eventId);
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("イベントページ"),
      ),
      body: FutureBuilder<Props>(
        future: initialProps(eventList, eventId),
        builder: (BuildContext context, AsyncSnapshot<Props> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.hasData && !snapshot.data!.event.exists) {
            return Center(child: Text("Event does not exist"));
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

          return Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Text(
                        '${eventData['title']}',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Text(
                        '👽投稿者: ${eventData['username']}',
                        style: const TextStyle(fontSize: 20),
                      )),
                  Container(
                      margin: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                      child: Text(
                        '📍このイベントへの参加希望日時を出す',
                        style: const TextStyle(fontSize: 20),
                      )),
                  Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextField(
                        controller: _userName,
                        maxLength: 10, // 入力数
                        maxLines: 1,
                        decoration: const InputDecoration(
                          hintText: '名前を入力して下さい',
                          labelText: '名前',
                        ),
                      )),
                  Column(
                    // 日時のチェックボックス
                    children: dateData
                        .map<Widget>((e) => CheckboxListTile(
                              title: Text('${e.data()['option']}'), // 日時
                              subtitle: Text(
                                  '👍 ${e.data()['reaction'] == null ? 'リアクションしているユーザーが居ません' : e.data()['reaction'].join(", ")}'), // リアクションした人の名前配列
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _dateDataReactionFlag[dateData.indexOf(e)],
                              onChanged: (bool? newValue) => {
                                setState(() {
                                  _dateDataReactionFlag[dateData.indexOf(e)] =
                                      newValue ?? false;
                                })
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onSubmitted,
        icon: Icon(Icons.check),
        label: Text("この日程で参加したい！"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
