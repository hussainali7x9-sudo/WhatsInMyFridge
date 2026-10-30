import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whats_in_my_fridge/main.dart'; // Apne project ka naam check kar lo

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // App build karo
    await tester.pumpWidget(const MyApp()); // FridgeApp ki jagah MyApp

    // Check karo ke MaterialApp majood hai
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}