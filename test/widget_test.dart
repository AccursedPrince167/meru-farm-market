
import 'package:flutter_test/flutter_test.dart';
import 'package:farmconnect/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('App loads and displays HomePage', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // Check that the HomePage title is present
    expect(find.text('Farm Connect'), findsOneWidget);

    // Check that action cards exist
    expect(find.text('Buy Produce'), findsOneWidget);
    expect(find.text('My Cart'), findsOneWidget);
    expect(find.text('Sell Produce'), findsOneWidget);

    // Check that footer message is present
    expect(find.text(
      'Welcome to FarmConnect - Direct-to-Consumer Marketplace 🌾'),
      findsOneWidget
    );
  });
}