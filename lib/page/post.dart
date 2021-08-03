import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPagePageState createState() => _PostPagePageState();
}

class _PostPagePageState extends State<PostPage> {
  TextEditingController _textEditingControllerUsername =
      TextEditingController();
  TextEditingController _textEditingControllerTitle = TextEditingController();

  _onSubmitted(String content) {
    CollectionReference posts = FirebaseFirestore.instance.collection('event');
    posts.add({
      "username": _textEditingControllerUsername,
      "title": _textEditingControllerTitle,
    });

    /// 入力欄をクリアにする
    _textEditingControllerUsername.clear();
    _textEditingControllerTitle.clear();
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
          onSubmitted: _onSubmitted,
          enabled: true,
          maxLength: 50, // 入力数
          maxLengthEnforced: false, // 入力上限になったときに、文字入力を抑制するか
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
          maxLengthEnforced: false, // 入力上限になったときに、文字入力を抑制するか
          style: TextStyle(color: Colors.black),
          obscureText: false,
          maxLines: 1,
          decoration: const InputDecoration(
            icon: Icon(Icons.speaker_notes),
            hintText: 'イベント名を入力して下さい',
            labelText: 'イベント名',
          ),
        ),
      ]),
    );
  }
}
