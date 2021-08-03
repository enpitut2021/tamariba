import 'package:flutter/material.dart';
 
class PostPage extends StatefulWidget {
 
  @override
  _PostPagePageState createState() => _PostPagePageState();
}
 
class _PostPagePageState extends State<PostPage> {
 
  TextEditingController _textEditingController = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("投稿画面"),
      ),
      body: Center(
        child: TextField(
          controller: _textEditingController,
          enabled: true,
          maxLength: 50, // 入力数
          maxLengthEnforced: false, // 入力上限になったときに、文字入力を抑制するか
          style: TextStyle(color: Colors.black),
          obscureText: false,
          maxLines:1 ,
          decoration: const InputDecoration(
            icon: Icon(Icons.speaker_notes),
            hintText: '投稿者名を記載します',
            labelText: '名前',
          ),
        ),
      ),
    );
  }
}