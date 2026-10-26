import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'main_screen.dart';

class HistoryScreen extends StatefulWidget {
  final int? userId;
  const HistoryScreen({super.key, this.userId});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _allTransactions = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  void _fetchHistory() async {
    // Jika userId tidak ada,ambil semua transaksi (untuk backward compatibility)
    final data = widget.userId != null 
        ? await DBHelper.instance.getTransactions(widget.userId!)
        : await DBHelper.instance.getTransactions(0);
    setState(() {
      _allTransactions = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi'), backgroundColor: Colors.red, foregroundColor: Colors.white),
      body: _allTransactions.isEmpty
          ? const Center(child: Text('Belum ada riwayat transaksi'))
          : ListView.builder(
              itemCount: _allTransactions.length,
              itemBuilder: (context, index) {
                final item = _allTransactions[index];
                final type = item['type'] ?? 'Pengeluaran';
                final isIncome = type == 'Pemasukan';
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isIncome ? Colors.green : Colors.orange,
                      child: Icon(
                        isIncome ? Icons.arrow_downward : Icons.arrow_upward, 
                        color: Colors.white,
                      ),
                    ),
                    title: Text(item['title']),
                    subtitle: Text('${item['category']} • ${item['date']}'),
                    trailing: Text(
                      '${isIncome ? '+' : '-'} Rp ${item['amount']}', 
                      style: TextStyle(
                        color: isIncome ? Colors.green : Colors.red, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}