import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pocket_tasks/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add a new task', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PocketTasks()));
    await tester.pumpAndSettle();

    // Tap FAB to open modal
    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    // Enter task title
    final titleField = find.byType(TextField);
    expect(titleField, findsOneWidget);
    await tester.enterText(titleField, 'Integration Task');

    // Tap Save button
    final saveBtn = find.widgetWithText(ElevatedButton, 'Save');
    expect(saveBtn, findsOneWidget);
    await tester.tap(saveBtn);
    await tester.pumpAndSettle();

    // Check the task appears in the list
    expect(find.text('Integration Task'), findsOneWidget);
  });

  testWidgets('Filter tasks by Done status', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PocketTasks()));
    await tester.pumpAndSettle();

    final filterBtn = find.byType(PopupMenuButton<String>);
    expect(filterBtn, findsOneWidget);
    await tester.tap(filterBtn);
    await tester.pumpAndSettle();

    final doneFilter = find.text('Done');
    expect(doneFilter, findsOneWidget);
    await tester.tap(doneFilter);
    await tester.pumpAndSettle();

    expect(find.textContaining('Done'), findsWidgets);
  });

  testWidgets('Toggle dark mode', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PocketTasks()));
    await tester.pumpAndSettle();

    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);

    final Switch themeSwitch = tester.widget(switchFinder);
    final initialValue = themeSwitch.value;

    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    final Switch toggledSwitch = tester.widget(switchFinder);
    expect(toggledSwitch.value, isNot(equals(initialValue)));
  });

  testWidgets('Sort tasks by due date asc', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PocketTasks()));
    await tester.pumpAndSettle();

    final sortBtn = find.byType(PopupMenuButton<String>);
    expect(sortBtn, findsOneWidget);
    await tester.tap(sortBtn);
    await tester.pumpAndSettle();

    final dueAsc = find.text('Sort by Due Date ↑');
    expect(dueAsc, findsOneWidget);
    await tester.tap(dueAsc);
    await tester.pumpAndSettle();

    expect(find.textContaining('Due:'), findsWidgets);
  });

  testWidgets('Tap on task opens correct tile (basic check)',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PocketTasks()));
    await tester.pumpAndSettle();

    // Find at least one task tile
    final taskTile = find.byType(ListTile).first;
    expect(taskTile, findsOneWidget);

    await tester.tap(taskTile);
    await tester.pumpAndSettle();
  });
}
