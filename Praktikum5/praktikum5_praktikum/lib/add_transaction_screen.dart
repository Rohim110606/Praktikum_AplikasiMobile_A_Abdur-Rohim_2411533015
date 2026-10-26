import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catat Transaksi'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nominal', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              // Input Tanggal dengan TextFormField dan showDatePicker
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  hintText: 'DD/MM/YYYY',
                  border: const OutlineInputBorder(),
                  // Tombol plus untuk membuka date picker
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      // Membuka showDatePicker
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      
                      // Jika tanggal dipilih, format ke DD/MM/YYYY
                      if (selectedDate != null) {
                        final formattedDate = 
                          '${selectedDate.day.toString().padLeft(2, '0')}/'
                          '${selectedDate.month.toString().padLeft(2, '0')}/'
                          '${selectedDate.year}';
                        
                        setState(() {
                          _dateController.text = formattedDate;
                        });
                      }
                    },
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Tanggal wajib diisi!' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Transaksi Berhasil Disimpan!')),
                    );
                    // NAVIGASI POP: Kembali ke halaman sebelumnya (Dashboard)
                    Navigator.pop(context);
                  }
                },
                child: const Text('Simpan', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}