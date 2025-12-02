import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';

class StorageService {
  static const String keyTransactions = 'TRANSACTIONS_LIST';

  // Ambil semua transaksi
  Future<List<TransactionModel>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(keyTransactions);
    if (data == null) return [];
    return TransactionModel.decode(data);
  }

  // Tambah transaksi baru
  Future<void> addTransaction(TransactionModel transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final List<TransactionModel> currentList = await getTransactions();
    
    // Tambahkan data baru ke paling atas (index 0)
    currentList.insert(0, transaction);
    
    // Simpan kembali
    await prefs.setString(keyTransactions, TransactionModel.encode(currentList));
  }

  // Hitung Total Saldo
  Future<double> getBalance() async {
    final list = await getTransactions();
    double income = 0;
    double expense = 0;
    for (var item in list) {
      if (item.isIncome) {
        income += item.amount;
      } else {
        expense += item.amount;
      }
    }
    return income - expense;
  }
}