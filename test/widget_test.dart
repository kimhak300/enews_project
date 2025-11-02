// This is a basic Flutter widget test for eNews app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newshub/main.dart';

void main() {
  testWidgets('eNews app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ENewsApp());

    // Verify that splash screen shows
    expect(find.text('eNews'), findsOneWidget);
    expect(find.byIcon(Icons.newspaper), findsOneWidget);
  });
}
