// Basic Flutter widget smoke test for Kamrai POS.

import 'dart:ui' show Size;

import 'package:flutter_test/flutter_test.dart';

import 'package:kumrai_pos/main.dart';
import 'package:kumrai_pos/screens/home_screen.dart';

void main() {
  testWidgets('KamraiPosApp shows home screen', (WidgetTester tester) async {
    // POS UI is laid out for landscape / wide screens; default 800×600 overflows.
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const KamraiPosApp());
    // Repeating animations (e.g. status dots) mean pumpAndSettle never completes.
    await tester.pump();

    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
