// √ボタンを作る
// √「Twitterで投稿する」という名前のボタンにする
// √遊びに行くボタンなどをつくる
// √そこをクリックしたら投稿するURLを開く
//

// TODOlist
// √ dummyTheme 変数を作る
// √ packageをimport
// PageTitleを変更する
// dummyThemeを表示する

// ehika調べた内容
// URLを開く https://qiita.com/superman9387/items/868ce6ad60b3c177bff1
// Twitterに投稿するURL https://publish.twitter.com/?buttonType=TweetButton&widget=Button
//<a href="https://twitter.com/share?ref_src=twsrc%5Etfw" class="twitter-share-button" data-show-count="false">Tweet</a><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

import 'package:flutter/material.dart';
import 'package:hello_world/page/home.dart';
import 'package:hello_world/page/theme-selection.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => Home(),
        '/theme-selection': (BuildContext context) => ThemeSelection(),
      },
    ),
  );
}
