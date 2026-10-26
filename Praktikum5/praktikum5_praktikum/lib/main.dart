import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'add_transaction_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker Final',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 7, 44, 255),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/add': (context) => const AddTransactionScreen(),
      },
    );
  }
}