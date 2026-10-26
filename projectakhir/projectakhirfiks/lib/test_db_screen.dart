import 'package:flutter/material.dart';
import 'db_helper.dart';

class TestDBScreen extends StatefulWidget {
  final int? userId;
  const TestDBScreen({super.key, this.userId});

  @override
  State<TestDBScreen> createState() => _TestDBScreenState();
}

class _TestDBScreenState extends State<TestDBScreen> {
  Future<void> _testDatabase(BuildContext context) async {
    final db = await DBHelper.instance.database;
    
    // 1. Cek struktur tabel
    final tableInfo = await db.rawQuery("PRAGMA table_info(transactions)");
    print('=== STRUKTUR TABEL ===');
    for (var row in tableInfo) {
      print(row);
    }
    
    // 2. Cek semua transaksi
    final transactions = await db.query('transactions');
    print('\n=== SEMUA TRANSAKSI (${transactions.length}) ===');
    for (var t in transactions) {
      print(t);
    }
    
    // 3. Cek perhitungan
    final income = await DBHelper.instance.getTotalIncome(widget.userId ?? 0);
    final expense = await DBHelper.instance.getTotalExpense(widget.userId ?? 0);
    final balance = await DBHelper.instance.getTotalBalance(widget.userId ?? 0);
    
    print('\n=== PERHITUNGAN ===');
    print('Pemasukan: $income');
    print('Pengeluaran: $expense');
    print('Saldo: $balance');
    
    // 4. Tampilkan di UI
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Transaksi: ${transactions.length}\n'
          'Pemasukan: Rp $income\n'
          'Pengeluaran: Rp $expense\n'
          'Saldo: Rp $balance',
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> _clearDatabase(BuildContext context) async {
    final db = await DBHelper.instance.database;
    await db.delete('transactions');
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Semua transaksi dihapus!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Database'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _testDatabase(context),
              child: const Text('Cek Database (lihat console)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _clearDatabase(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus Semua Transaksi'),
            ),
          ],
        ),
      ),
    );
  }
}