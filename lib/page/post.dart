import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:hello_world/page/event.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPagePageState createState() => _PostPagePageState();
}

class _PostPagePageState extends State<PostPage> {
  // text editing controller
  TextEditingController _textEditingControllerUsername =
      TextEditingController();
  TextEditingController _textEditingControllerTitle = TextEditingController();
  // 日付作成
  var _mydatetimeStart = new DateTime.now(); // 開始時刻
  var _mydatetimeEnd = new DateTime.now(); // 終了時刻
  var formatter = new DateFormat('yyyy/MM/dd(E) HH:mm');
  List<String> _candidate = [];

  // _mydatetimeStartと_mydatetimeEndを整形してdatetimeを作る関数
  _dateCreate() {
    var mydatetime = _mydatetimeStart.year.toString() +
        '/' +
        _mydatetimeStart.month.toString() +
        '/' +
        _mydatetimeStart.day.toString() +
        ' ' +
        _mydatetimeStart.hour.toString() +
        ':' +
        _mydatetimeStart.minute.toString() +
        '~' +
        _mydatetimeEnd.year.toString() +
        '/' +
        _mydatetimeEnd.month.toString() +
        '/' +
        _mydatetimeEnd.day.toString() +
        ' ' +
        _mydatetimeEnd.hour.toString() +
        ':' +
        _mydatetimeEnd.minute.toString();
    return mydatetime;
  }

  _onSubmitted() async {
    CollectionReference posts = FirebaseFirestore.instance.collection('event');
    var posted = await posts.add({
      "username": _textEditingControllerUsername.text,
      "title": _textEditingControllerTitle.text,
    });

    if (_candidate.length == 0) {
      // _candidateが空の状態で投稿する場合
      var mydatetime = _dateCreate();
      await posts
          .doc(posted.id)
          .collection('optionList')
          .add({"option": mydatetime});
    } else {
      // 複数の日程候補がある場合
      for (var i in _candidate) {
        await posts.doc(posted.id).collection('optionList').add({"option": i});
      }
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EventPage(eventId: posted.id);
    }));

    /// 入力欄をクリアにする
    _textEditingControllerUsername.clear();
    _textEditingControllerTitle.clear();
  }

  _dateAdded() {
    var mydatetime = _dateCreate();
    setState(() {
      _candidate.add(mydatetime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("投稿画面"),
      ),
      body: Column(children: [
        TextField(
          controller: _textEditingControllerUsername,
          enabled: true,
          maxLength: 50, // 入力数
          //maxLengthEnforced: false, // 入力上限になったときに、文字入力を抑制するか
          style: TextStyle(color: Colors.black),
          obscureText: false,
          maxLines: 1,
          decoration: const InputDecoration(
            icon: Icon(Icons.speaker_notes),
            hintText: '投稿者名を入力して下さい',
            labelText: '名前',
          ),
        ),
        TextField(
          controller: _textEditingControllerTitle,
          enabled: true,
          maxLength: 50, // 入力数
          //maxLengthEnforcement: false, // 入力上限になったときに、文字入力を抑制するか
          style: TextStyle(color: Colors.black),
          obscureText: false,
          maxLines: 1,
          decoration: const InputDecoration(
            icon: Icon(Icons.speaker_notes),
            hintText: 'イベント名を入力して下さい',
            labelText: 'イベント名',
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(children: [
              TextButton(
                onPressed: () {
                  DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    // onChanged内の処理はDatepickerの選択に応じて毎回呼び出される
                    onChanged: (date) {
                      // print('change $date');
                    },
                    // onConfirm内の処理はDatepickerで選択完了後に呼び出される
                    onConfirm: (date) {
                      setState(() {
                        _mydatetimeStart = date;
                      });
                    },
                    // Datepickerのデフォルトで表示する日時
                    currentTime: DateTime.now(),
                    // localによって色々な言語に対応
                    //  locale: LocaleType.en
                  );
                },
                //tooltip: 'Datetime',
                //child: Icon(Icons.access_time),

                child: Text(
                  'イベント開始日時を選択',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Text(
                // フォーマッターを使用して指定したフォーマットで日時を表示
                // format()に渡すのはDate型の値で、String型で返される
                formatter.format(_mydatetimeStart),
                style: Theme.of(context).textTheme.display1,
              ),
            ]),
            Column(children: [
              TextButton(
                onPressed: () {
                  DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    // onChanged内の処理はDatepickerの選択に応じて毎回呼び出される
                    onChanged: (date) {
                      // print('change $date');
                    },
                    // onConfirm内の処理はDatepickerで選択完了後に呼び出される
                    onConfirm: (date) {
                      setState(() {
                        _mydatetimeEnd = date;
                      });
                    },
                    // Datepickerのデフォルトで表示する日時
                    currentTime: DateTime.now(),
                    // localによって色々な言語に対応
                    //  locale: LocaleType.en
                  );
                },
                //tooltip: 'Datetime',
                //child: Icon(Icons.access_time),

                child: Text(
                  'イベント終了日時を選択',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Text(
                // フォーマッターを使用して指定したフォーマットで日時を表示
                // format()に渡すのはDate型の値で、String型で返される
                formatter.format(_mydatetimeEnd),
                style: Theme.of(context).textTheme.display1,
              ),
            ]),
          ],
        ),
        TextButton(
            onPressed: () => {_dateAdded()}, child: Text('イベント候補日時を追加する')),
        Column(children: _candidate.map<Widget>((e) => Text(e)).toList()),
        TextButton(
          onPressed: _onSubmitted,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              child: Text('投稿'),
            ),
          ),
        ),
      ]),
    );
  }
}
