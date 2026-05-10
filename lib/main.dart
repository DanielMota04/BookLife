import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        body: Center(child: Text('Olá!')),
      ),
    );
  }
}