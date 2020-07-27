import 'package:flutter/material.dart';
import 'screens/home.dart';

void main() {
  runApp(CredicxoTask());
}

class CredicxoTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
      },
    );
  }
}
