// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:moneyu_moyohi/main.dart'; // Pastikan nama package ini sesuai dengan di pubspec.yaml

void main() {
  testWidgets('Pin Setup Screen smoke test', (WidgetTester tester) async {
    // 1. Build aplikasi MoneyUApp
    // Kita simulasikan sebagai user baru (startWithPinSetup: true)
    await tester.pumpWidget(const MoneyUApp(startWithPinSetup: true));

    // 2. Verifikasi bahwa halaman yang muncul adalah "Buat Sandi Anda"
    // Mencari teks judul di halaman PinSetup
    expect(find.text('Buat Sandi Anda'), findsOneWidget);

    // 3. Pastikan halaman "Masukkan Sandi" TIDAK muncul
    expect(find.text('Masukkan Sandi Anda'), findsNothing);

    // 4. Verifikasi adanya tombol SIMPAN
    expect(find.text('SIMPAN'), findsOneWidget);
  });
}