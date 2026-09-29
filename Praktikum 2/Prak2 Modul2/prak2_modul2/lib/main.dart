import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 1. WIDGET UTAMA (Root Aplikasi)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DashboardScreen(),
    );
  }
}

// 2. HALAMAN UTAMA (Scaffold) - DIPERBAIKI
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum 2: Layouting'),
        backgroundColor: Colors.blue,
      ),
      // Padding untuk memberi jarak dari tepi agar layer bisa di-scroll
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GreetingWidget(),        // Daru Modul 1
              SizedBox(height: 20),
              BalanceCardWidget(),     // Daru Modul 2
              SizedBox(height: 20),
              // WIDGET BARU MODUL 2
              ActionButtonWidget(),
              SizedBox(height: 20),
              RecentTransactionWidget(),  // WIDGET BARU MODUL 2
            ],
          ),
        ),
      ),
    );
  }
}

// 3. STATELESS WIDGET (Sapaan - Daru Modul 1)
class GreetingWidget extends StatelessWidget {
  const GreetingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person, size: 30, color: Colors.white),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Halo, Rohim!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Selamat datang kembali!', style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

// 4. STATEFUL WIDGET (Kartu Saldo - Daru Modul 1)
class BalanceCardWidget extends StatefulWidget {
  const BalanceCardWidget({super.key});

  @override
  State<BalanceCardWidget> createState() => _BalanceCardWidgetState();
}

class _BalanceCardWidgetState extends State<BalanceCardWidget> {
  bool _isBalanceVisible = true;

  void _toggleVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Saldo Utama', style: TextStyle(fontSize: 16, color: Colors.white70)),
                IconButton(
                  icon: Icon(_isBalanceVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white),
                  onPressed: _toggleVisibility,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _isBalanceVisible ? 'Rp 5.000.000' : 'Rp **********',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// 5. TOMBOL AKSI (ROW & LISTFILE) - BARU
class ActionButtonWidget extends StatelessWidget {
  const ActionButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(Icons.arrow_downward, 'Pemasukan', Colors.green),
        _buildActionButton(Icons.arrow_upward, 'Pengeluaran', Colors.red),
        _buildActionButton(Icons.swap_horiz, 'Transfer', Colors.blue),
      ],
    );
  }

  // Fungsi pembantu untuk membuat desain tombol agar kode tidak berulang
  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        // Container untuk membungkus icon dengan warna background
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2), // Warna transparan
            shape: BoxShape.circle, // Bentuk bulat
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

// 6. WIDGET DAFTAR TRANSAKSI (COLUMN & LISTTILE) - BARU
class RecentTransactionWidget extends StatelessWidget {
  const RecentTransactionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaksi Terakhir',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        // Penggunaan Card agar daftar transaksi memiliki bayangan/singkat
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              // Item Transaksi 1
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.shopping_cart, color: Colors.white),
                ),
                title: const Text('Makan Siang'),
                subtitle: const Text('12 Sep 2024'), // Tanggal status
                trailing: const Text(
                  '- Rp 50.000',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold), // TUGAS 1: Warna merah untuk pengeluaran
                ),
              ),
              const Divider(height: 1), // Garis pemisah
              // Item Transaksi 2
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.attach_money, color: Colors.white),
                ),
                title: const Text('Gaji Bulanan'),
                subtitle: const Text('10 Sep 2024'),
                trailing: const Text(
                  '+ Rp 5.000.000',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold), // TUGAS 1: Warna hijau untuk pemasukan
                ),
              ),
              const Divider(height: 1),
              // Item Transaksi 3
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.directions_car, color: Colors.white),
                ),
                title: const Text('Isi Bensin'),
                subtitle: const Text('10 Sep 2024'),
                trailing: const Text(
                  '- Rp 150.000',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold), // TUGAS 1: Warna merah untuk pengeluaran
                ),
              ),
              const Divider(height: 1),
              // TUGAS 2: Transaksi 4 (BARU)
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.coffee, color: Colors.white),
                ),
                title: const Text('Beli Kopi'),
                subtitle: const Text('15 Sep 2024'),
                trailing: const Text(
                  '- Rp 25.000',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1),
              // TUGAS 2: Transaksi 5 (BARU)
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.card_giftcard, color: Colors.white),
                ),
                title: const Text('Bonus Proyek'),
                subtitle: const Text('14 Sep 2024'),
                trailing: const Text(
                  '+ Rp 1.000.000',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}