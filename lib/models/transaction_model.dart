import 'dart:convert';

class TransactionModel {
  final String title;      // Keterangan (Contoh: Beli Makan)
  final String category;   // Kategori (Contoh: Makanan, Transport)
  final double amount;     // Jumlah Uang
  final bool isIncome;     // True = Pemasukan, False = Pengeluaran
  final String date;       // Tanggal transaksi

  TransactionModel({
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.date,
  });

  // Mengubah data ke format JSON (Teks) agar bisa disimpan
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'amount': amount,
      'isIncome': isIncome,
      'date': date,
    };
  }

  // Mengubah JSON kembali ke data asli
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      title: map['title'] ?? '',
      category: map['category'] ?? 'Umum',
      amount: map['amount']?.toDouble() ?? 0.0,
      isIncome: map['isIncome'] ?? false,
      date: map['date'] ?? '',
    );
  }

  static String encode(List<TransactionModel> transactions) => json.encode(
        transactions.map<Map<String, dynamic>>((t) => t.toMap()).toList(),
      );

  static List<TransactionModel> decode(String transactions) =>
      (json.decode(transactions) as List<dynamic>)
          .map<TransactionModel>((item) => TransactionModel.fromMap(item))
          .toList();
}