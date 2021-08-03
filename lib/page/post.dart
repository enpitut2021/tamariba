import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPagePageState createState() => _PostPagePageState();
}

class _PostPagePageState extends State<PostPage> {
  TextEditingController _textEditingControllerUsername =
      TextEditingController();
  TextEditingController _textEditingControllerTitle = TextEditingController();

  _onSubmitted(_textEditingControllerUsername, _textEditingControllerTitle) {
    CollectionReference posts = FirebaseFirestore.instance.collection('event');
    posts.add({
      "username": _textEditingControllerUsername.text,
      "title": _textEditingControllerTitle.text,
    });

    /// 入力欄をクリアにする
    _textEditingControllerUsername.clear();
    _textEditingControllerTitle.clear();
  }

  // 日付作成
  var _mydatetime = new DateTime.now();
  var formatter = new DateFormat('yyyy/MM/dd(E) HH:mm');

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
                  _mydatetime = date;
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
            'show date picker(custom theme &date time range)',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        Text(
          // フォーマッターを使用して指定したフォーマットで日時を表示
          // format()に渡すのはDate型の値で、String型で返される
          formatter.format(_mydatetime),
          style: Theme.of(context).textTheme.display1,
        ),
        TextButton(
            onPressed: () => {
                  _onSubmitted(_textEditingControllerUsername,
                      _textEditingControllerTitle)
                },
            child: Text('投稿'))
      ]),
    );
  }
}
