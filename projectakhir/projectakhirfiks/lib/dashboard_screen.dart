import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'add_transaction_screen.dart';
import 'transaction_detail_screen.dart';
import 'test_db_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String userName;
  final int userId;
  const DashboardScreen({super.key, required this.userName, required this.userId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> _transactions = [];
  bool _isBalanceVisible = true;
  double _totalBalance = 0.0;
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final data = await DBHelper.instance.getTransactions(widget.userId);
    final income = await DBHelper.instance.getTotalIncome(widget.userId);
    final expense = await DBHelper.instance.getTotalExpense(widget.userId);
    
    print('[Dashboard] User: ${widget.userId}, Transaksi: ${data.length}');
    print('[Dashboard] Pemasukan: $income, Pengeluaran: $expense, Saldo: ${income - expense}');
    
    setState(() {
      _transactions = data;
      _totalIncome = income;
      _totalExpense = expense;
      _totalBalance = income - expense;
    });
  }

  Widget _buildStatItem(String label, double amount, Color color) {
    return Row(
      children: [
        Icon(
          label == 'Pemasukan' ? Icons.arrow_downward : Icons.arrow_upward,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          '$label: Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
        title: const Text('Dashboard Keuangan'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TestDBScreen(userId: widget.userId),
                ),
              );
            },
            tooltip: 'Debug Database',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => AddTransactionScreen(userId: widget.userId),
            ),
          );
          _loadData(); // Refresh data setelah transaksi ditambahkan
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Halo, ${widget.userName}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            // Kartu Saldo (Stateful / Toggle Visibility)[cite: 12, 16]
            Card(
              elevation: 4,
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Saldo Utama', style: TextStyle(fontSize: 16, color: Colors.white70)),
                        IconButton(
                          icon: Icon(_isBalanceVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white),
                          onPressed: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isBalanceVisible ? 'Rp ${_totalBalance.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}' : 'Rp **********',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem('Pemasukan', _totalIncome, Colors.green),
                        _buildStatItem('Pengeluaran', _totalExpense, Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Transaksi Terakhir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _transactions.isEmpty
                ? const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('Belum ada transaksi')))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _transactions.length > 3 ? 3 : _transactions.length,
                    itemBuilder: (context, index) {
                      final item = _transactions[index];
                      final type = item['type'] ?? 'Pengeluaran';
                      final isIncome = type == 'Pemasukan';
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isIncome ? Colors.green : Colors.orange,
                            child: Icon(
                              isIncome ? Icons.arrow_downward : Icons.arrow_upward, 
                              color: Colors.white,
                            ),
                          ),
                          title: Text(item['title']),
                          subtitle: Text('${item['date']} • $type'),
                          trailing: Text(
                            '${isIncome ? '+' : '-'} Rp ${item['amount']}', 
                            style: TextStyle(
                              color: isIncome ? Colors.green : Colors.red, 
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionDetailScreen(
                                  title: item['title'],
                                  amount: 'Rp ${item['amount']}',
                                  category: item['category'],
                                  date: item['date'],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}