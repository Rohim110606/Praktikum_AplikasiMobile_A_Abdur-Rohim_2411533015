import 'package:flutter/material.dart';
import 'dashboard_screen.dart'; // Dari modul sebelumnya
import 'profile_screen.dart'; // Akan dibuat sebagai tugas akhir mahasiswa
import 'history_screen.dart';

class MainScreen extends StatefulWidget {
  final String email;
  
  const MainScreen({super.key, required this.email});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Tab pertama aktif secara default (Beranda)

  // List kumpulan halaman 
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const DashboardScreen(),
      const HistoryScreen(),
      ProfileScreen(email: widget.email),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex], // Ganti layer sesuai index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.amber[800],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}