import 'package:flutter/material.dart';
import 'transaction_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Semua Transaksi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTransactionHistoryList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHistoryList(BuildContext context) {
    // Data dummy untuk riwayat transaksi
    final transactions = [
      {
        'title': 'Makan Siang',
        'amount': '- Rp 50.000',
        'category': 'Makanan',
        'date': '13 September 2026',
        'icon': Icons.fastfood,
        'color': Colors.orange,
        'amountColor': Colors.red,
      },
      {
        'title': 'Gaji Bulanan',
        'amount': 'Rp 5.000.000',
        'category': 'Pemasukan',
        'date': '1 September 2026',
        'icon': Icons.attach_money,
        'color': Colors.green,
        'amountColor': Colors.green,
      },
      {
        'title': 'Bensin',
        'amount': '- Rp 75.000',
        'category': 'Transportasi',
        'date': '10 September 2026',
        'icon': Icons.local_gas_station,
        'color': Colors.blue,
        'amountColor': Colors.red,
      },
      {
        'title': 'Belanja Groceries',
        'amount': '- Rp 120.000',
        'category': 'Belanja',
        'date': '8 September 2026',
        'icon': Icons.shopping_cart,
        'color': Colors.purple,
        'amountColor': Colors.red,
      },
      {
        'title': 'Listrik',
        'amount': '- Rp 250.000',
        'category': 'Tagihan',
        'date': '5 September 2026',
        'icon': Icons.lightbulb,
        'color': Colors.yellow,
        'amountColor': Colors.red,
      },
    ];

    return Column(
      children: List.generate(
        transactions.length,
        (index) {
          final tx = transactions[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionDetailScreen(
                    title: tx['title'] as String,
                    amount: tx['amount'] as String,
                    category: tx['category'] as String,
                    date: tx['date'] as String,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: tx['color'] as Color,
                  child: Icon(tx['icon'] as IconData, color: Colors.white),
                ),
                title: Text(
                  tx['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  tx['date'] as String,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                trailing: Text(
                  tx['amount'] as String,
                  style: TextStyle(
                    color: tx['amountColor'] as Color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}