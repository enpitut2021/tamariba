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
import 'package:hello_world/page/event.dart';
import 'package:hello_world/page/eventList.dart';
import 'package:hello_world/page/themeSelection.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.
class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text('error:${snapshot.error}');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              '/': (BuildContext context) => ThemeSelection(),
              '/theme-selection': (BuildContext context) => ThemeSelection(),
              '/event-list': (context) => EventListPage(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/event') {
                return MaterialPageRoute(
                  builder: (context) => EventPage(
                      eventId: (settings.arguments as dynamic)["eventId"]),
                );
              }
              return null;
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Text('Loading...');
      },
    );
  }
}
