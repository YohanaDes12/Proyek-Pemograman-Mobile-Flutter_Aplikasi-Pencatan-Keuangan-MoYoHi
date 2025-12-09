import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';
import 'home_screen.dart';
import 'analysis_screen.dart';
import 'models/transaction_model.dart';
import 'services/storage_service.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final StorageService _storage = StorageService();
  List<TransactionModel> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final list = await _storage.getTransactions();
    setState(() {
      _transactions = list;
    });
  }

  String formatRupiah(double amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.bluePrimary,
        title: const Text("Catatan Keuangan", style: TextStyle(color: Colors.white)),
        elevation: 0,
        automaticallyImplyLeading: false, 
      ),
      body: _transactions.isEmpty 
          ? const Center(child: Text("Belum ada catatan transaksi"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final item = _transactions[index];
                return _buildNoteItem(item);
              },
            ),
            
      // --- FOOTER NAVIGASI (Index 0) ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: AppColors.bluePrimary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) {
            // Pindah ke Dompet
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          } else if (index == 2) {
            // Pindah ke Analisis
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AnalysisScreen()));
          }
        },
        items: [
          // ITEM 1: BUKU
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/icon_2.png', width: 32, height: 32, color: Colors.white70),
            activeIcon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white12,
                shape: BoxShape.circle,
              ),
              child: Image.asset('assets/images/icon_2.png', width: 28, height: 28, color: Colors.white),
            ),
            label: "Buku",
          ),
          // ITEM 2: DOMPET
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/icon_1.png', width: 32, height: 32, color: Colors.white70),
            activeIcon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white12,
                shape: BoxShape.circle,
              ),
              child: Image.asset('assets/images/icon_1.png', width: 28, height: 28, color: Colors.white),
            ),
            label: "Dompet",
          ),
          // ITEM 3: ANALISIS
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/icon_3.png', width: 32, height: 32, color: Colors.white70),
            activeIcon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white12,
                shape: BoxShape.circle,
              ),
              child: Image.asset('assets/images/icon_3.png', width: 28, height: 28, color: Colors.white),
            ),
            label: "Analisis",
          ),
        ],
      ),
    );
  }

  Widget _buildNoteItem(TransactionModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.blueSoft),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item.isIncome ? AppColors.greenIncome.withOpacity(0.1) : AppColors.redExpense.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: item.isIncome ? AppColors.greenIncome : AppColors.redExpense,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                Text(item.category + " • " + item.date, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(
            (item.isIncome ? "+ " : "- ") + formatRupiah(item.amount),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: item.isIncome ? AppColors.greenIncome : AppColors.redExpense,
            ),
          ),
        ],
      ),
    );
  }
}