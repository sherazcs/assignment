import 'package:assignment_task/src/features/items/presentation/main_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('MainScreen displays a list of items', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: MainScreen(),
        ),
      ),
    );

    // Verify UI elements
    expect(find.text('Main Screen'), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
