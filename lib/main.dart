import 'package:flutter/material.dart';
import 'package:hello_world/page/eventList.dart';
import 'package:hello_world/page/themeSelection.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class TabInfo {
  String label;
  Widget widget;
  TabInfo(this.label, this.widget);
}

class MyApp extends StatelessWidget {
  final List<TabInfo> _tabs = [
    TabInfo("イベント作成", ThemeSelection()),
    TabInfo("イベント一覧", EventListPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('タマリバ'),
          bottom: PreferredSize(
            child: TabBar(
              isScrollable: true,
              tabs: _tabs.map((TabInfo tab) {
                return Tab(text: tab.label);
              }).toList(),
            ),
            preferredSize: Size.fromHeight(30.0),
          ),
        ),
        body: TabBarView(children: _tabs.map((tab) => tab.widget).toList()),
      ),
    );
  }
}
