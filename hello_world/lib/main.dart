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

// var firebaseConfig = {
//         apiKey: "AIzaSyDRL718fwPKeR9yaoPv8HctlSkHbJBcrCs",
//         authDomain: "tamariba.firebaseapp.com",
//         projectId: "tamariba",
//         storageBucket: "tamariba.appspot.com",
//         messagingSenderId: "1059122947072",
//         appId: "1:1059122947072:web:f7917e2de1bc20d097a4e5",
//         measurementId: "G-9K473SGSNQ",
//       };

import 'package:flutter/material.dart';
import 'package:hello_world/page/home.dart';
import 'package:hello_world/page/theme-selection.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

void main() {
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
