import 'package:flutter/material.dart';

void main() {
  runApp(const BookLifeApp());
}

class BookLifeApp extends StatelessWidget {
  const BookLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookLife',
      home: Scaffold(
        appBar: AppBar(title: Text('BookLife')),
        body: Center(child: Text('')),
      ),
    );
  }
}