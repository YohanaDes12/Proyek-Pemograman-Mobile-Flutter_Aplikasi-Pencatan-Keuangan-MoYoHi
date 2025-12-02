import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart'; 
import 'constants.dart';

class PinScreen extends StatefulWidget {
  final bool isSetup; // True = Buat PIN Baru, False = Masukkan PIN
  const PinScreen({super.key, required this.isSetup});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  // Simpan PIN (Mirip PinSetupActivity.kt)
  Future<void> _savePin() async {
    if (_pinController.text.length == 6) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('USER_PIN', _pinController.text);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("PIN Berhasil dibuat!")),
        );
        // Setelah buat, pindah ke mode verifikasi
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const PinScreen(isSetup: false))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PIN harus 6 digit")),
      );
    }
  }

  // Cek PIN (Mirip PinVerifyActivity.kt)
  Future<void> _verifyPin() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedPin = prefs.getString('USER_PIN');

    if (savedPin == _pinController.text) {
      if (mounted) {
        // PIN Benar -> Masuk Home
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const HomeScreen())
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PIN Salah!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Biru + Logo
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: AppColors.bluePrimary,
              alignment: Alignment.center,
              child: Image.asset('assets/ic_logo.png', width: 120, height: 120),
            ),
          ),
          // Form Input
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    widget.isSetup ? "Buat Sandi Anda" : "Masukkan Sandi Anda",
                    style: const TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold, 
                      color: AppColors.textPrimary
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    obscureText: true, // Sembunyikan karakter
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 28, letterSpacing: 8),
                    decoration: InputDecoration(
                      hintText: "******",
                      filled: true,
                      fillColor: Colors.grey[200],
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), 
                        borderSide: BorderSide.none
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueChip,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: widget.isSetup ? _savePin : _verifyPin,
                    child: Text(widget.isSetup ? "SIMPAN" : "MASUK"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}