import 'package:flutter/material.dart';
import 'package:flutter_simple_ping/src/presentation/home/home_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Ping',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColorDark: Colors.black45,
      ),
      home: const HomePage(title: 'Simple Ping'),
    );
  }
}
