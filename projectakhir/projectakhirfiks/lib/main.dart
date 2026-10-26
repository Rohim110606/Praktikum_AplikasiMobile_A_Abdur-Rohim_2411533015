import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'test_db_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker Proyek Akhir',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const LoginScreen(),
      routes: {
        '/test-db': (context) => TestDBScreen(userId: ModalRoute.of(context)!.settings.arguments as int?),
      },
    );
  }
}