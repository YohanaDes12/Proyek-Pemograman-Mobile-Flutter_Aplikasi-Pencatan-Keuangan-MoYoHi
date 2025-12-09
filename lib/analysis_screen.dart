import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'constants.dart';
import 'home_screen.dart';
import 'notes_screen.dart';
import 'services/storage_service.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final StorageService _storage = StorageService();
  
  Map<String, double> _categoryTotals = {};
  double _totalExpense = 0;

  final List<Color> _colorPalette = [
    AppColors.blueChip,
    AppColors.redChip,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.amber,
  ];

  @override
  void initState() {
    super.initState();
    _calculateAnalysis();
  }

  Future<void> _calculateAnalysis() async {
    final list = await _storage.getTransactions();
    Map<String, double> tempTotals = {};
    double tempTotalExpense = 0;

    for (var item in list) {
      if (!item.isIncome) { 
        tempTotalExpense += item.amount;
        if (tempTotals.containsKey(item.category)) {
          tempTotals[item.category] = tempTotals[item.category]! + item.amount;
        } else {
          tempTotals[item.category] = item.amount;
        }
      }
    }

    if (mounted) {
      setState(() {
        _categoryTotals = tempTotals;
        _totalExpense = tempTotalExpense;
      });
    }
  }

  String formatRupiah(double amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, double>> categoryList = _categoryTotals.entries.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: AppColors.bluePrimary,
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 20),
            child: const Text(
              "Analisis Pengeluaran",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_totalExpense > 0)
                  SizedBox(
                    height: 320,  // ← Tinggi ditambah untuk ruang persentase & legend
                    child: Column(
                      children: [
                        SizedBox(
                          height: 220,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2, 
                              centerSpaceRadius: 40,
                              sections: List.generate(categoryList.length, (index) {
                                final entry = categoryList[index];
                                final percentage = (entry.value / _totalExpense) * 100;
                                final color = _colorPalette[index % _colorPalette.length];
                                
                                return PieChartSectionData(
                                  color: color,
                                  value: entry.value,
                                  title: '',  // ← Kosongkan title (persentase akan di luar)
                                  radius: 60,
                                );
                              }),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Legend & Persentase
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: List.generate(categoryList.length, (index) {
                            final entry = categoryList[index];
                            final percentage = (entry.value / _totalExpense) * 100;
                            final color = _colorPalette[index % _colorPalette.length];
                            
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${entry.key} (${percentage.toStringAsFixed(1)}%)',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.pie_chart_outline, size: 60, color: Colors.grey[300]),
                          const SizedBox(height: 10),
                          const Text("Belum ada data grafik", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
                    border: Border.all(color: AppColors.blueSoft),
                  ),
                  child: Column(
                    children: [
                      const Text("Total Pengeluaran", style: TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      Text(formatRupiah(_totalExpense), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.redExpense)),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                const Text("Rincian Kategori", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                if (_categoryTotals.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: Text("Belum ada data pengeluaran", style: TextStyle(color: Colors.grey))),
                  )
                else
                  ...List.generate(categoryList.length, (index) {
                    final entry = categoryList[index];
                    final color = _colorPalette[index % _colorPalette.length];
                    return _buildCategoryItem(entry.key, entry.value, color);
                  }),
              ],
            ),
          ),
        ],
      ),
      
      // --- FOOTER NAVIGASI (konstan di semua screen) ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        backgroundColor: AppColors.bluePrimary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NotesScreen()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          }
        },
        items: [
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

  Widget _buildCategoryItem(String category, double amount, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blueSoft),
      ),
      child: Row(
        children: [
          Container(
            width: 16, height: 16, 
            decoration: BoxDecoration(
              color: color, 
              shape: BoxShape.circle
            )
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(category, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ),
          Text(formatRupiah(amount), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}