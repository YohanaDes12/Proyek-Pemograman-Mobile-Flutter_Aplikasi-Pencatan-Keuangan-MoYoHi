import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';
import 'notes_screen.dart';
import 'analysis_screen.dart';
import 'models/transaction_model.dart';
import 'services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storage = StorageService();
  
  // -- State Data --
  double _totalBalance = 0;
  double _totalIncome = 0;
  double _totalExpense = 0;
  
  // -- State UI Baru: Mode Pemasukan atau Pengeluaran --
  bool _isExpenseMode = false; // false = Pemasukan (Biru), true = Pengeluaran (Merah)

  // -- Controllers --
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  // Tambahan controller untuk kategori
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  // Ambil data saldo
  Future<void> _refreshData() async {
    final list = await _storage.getTransactions();
    double income = 0;
    double expense = 0;

    for (var item in list) {
      if (item.isIncome) income += item.amount;
      else expense += item.amount;
    }

    if (mounted) {
      setState(() {
        _totalIncome = income;
        _totalExpense = expense;
        _totalBalance = income - expense;
      });
    }
  }

  // -- Logika Simpan Transaksi --
  Future<void> _saveTransaction() async {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Masukkan nominal yang valid")));
      return;
    }

    // Tentukan kategori otomatis jika kosong
    String category = _categoryController.text;
    if (category.isEmpty) {
      category = _isExpenseMode ? 'Umum' : 'Gaji/Masuk';
    }

    final newTransaction = TransactionModel(
      // Judul otomatis jika kosong
      title: _noteController.text.isEmpty 
          ? (_isExpenseMode ? 'Pengeluaran' : 'Pemasukan') 
          : _noteController.text,
      category: category,
      amount: amount,
      isIncome: !_isExpenseMode, // Jika mode Expense aktif, berarti isIncome = false
      date: DateFormat('dd MMM yyyy').format(DateTime.now()),
    );

    await _storage.addTransaction(newTransaction);

    // Reset Form
    _amountController.clear();
    _noteController.clear();
    _categoryController.clear();
    FocusManager.instance.primaryFocus?.unfocus(); // Tutup keyboard
    _refreshData();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Berhasil menyimpan ${_isExpenseMode ? 'Pengeluaran' : 'Pemasukan'}"),
        backgroundColor: _isExpenseMode ? AppColors.redExpense : AppColors.greenIncome,
      ));
    }
  }

  String formatRupiah(double amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    // Warna aktif berubah sesuai tab (Merah/Biru)
    Color activeColor = _isExpenseMode ? AppColors.redExpense : AppColors.blueChip;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- HEADER & SALDO (Sama seperti sebelumnya) ---
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(height: 160, color: AppColors.bluePrimary),
              Positioned(
                bottom: -40,
                left: 20, right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    children: [
                      const Text("Total Saldo", style: TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text(
                        formatRupiah(_totalBalance),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 50),

          // --- CONTENT UTAMA ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // Panel Ringkasan Kecil
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.yellowSoft,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _summaryItem("Pemasukan", formatRupiah(_totalIncome), AppColors.blueChip, true),
                      const SizedBox(width: 8),
                      _summaryItem("Pengeluaran", formatRupiah(_totalExpense), AppColors.redExpense, false),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // --- FORM TAB BARU (INPUT TRANSAKSI) ---
                // Ini bagian yang menggantikan tombol lama
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.blueSoft),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      // 1. Tab Bar (Pemasukan | Pengeluaran)
                      Row(
                        children: [
                          // Tab Pemasukan
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isExpenseMode = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: !_isExpenseMode ? AppColors.blueChip : Colors.grey[100],
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16)),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Pemasukan",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: !_isExpenseMode ? Colors.white : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Tab Pengeluaran
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isExpenseMode = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: _isExpenseMode ? AppColors.redExpense : Colors.grey[100],
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(16)),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Pengeluaran",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _isExpenseMode ? Colors.white : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // 2. Isi Form (Berubah sesuai Tab)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isExpenseMode ? "Input Pengeluaran" : "Input Pemasukan",
                              style: TextStyle(fontWeight: FontWeight.bold, color: activeColor, fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            
                            // Input Nominal
                            TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecor("Nominal (Rp)", activeColor),
                            ),
                            const SizedBox(height: 12),

                            // Input Kategori (Hanya muncul jika mode Pengeluaran)
                            if (_isExpenseMode) ...[
                              TextField(
                                controller: _categoryController,
                                decoration: _inputDecor("Kategori (Cth: Makan, Transport)", activeColor),
                              ),
                              const SizedBox(height: 12),
                            ],

                            // Input Catatan
                            TextField(
                              controller: _noteController,
                              decoration: _inputDecor("Catatan (Opsional)", activeColor),
                            ),
                            const SizedBox(height: 20),

                            // Tombol Simpan
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: activeColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 2,
                                ),
                                onPressed: _saveTransaction,
                                child: const Text("SIMPAN TRANSAKSI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
      // Bottom Navigasi
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, 
        selectedItemColor: AppColors.blueChip,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NotesScreen()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AnalysisScreen()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/ic_book.png')), label: "Buku"),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/ic_wallet.png')), label: "Dompet"),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/ic_insight.png')), label: "Analisis"),
        ],
      ),
    );
  }

  Widget _summaryItem(String title, String value, Color color, bool isAdd) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Image.asset(isAdd ? 'assets/ic_add.png' : 'assets/ic_remove.png', width: 16, color: color),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecor(String hint, Color activeColor) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[50],
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: activeColor, width: 2)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}