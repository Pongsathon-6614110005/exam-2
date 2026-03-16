import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:isar/isar.dart';
import 'package:smart_vision_journal/features/note/data/datasources/note_schema.dart';
import 'package:smart_vision_journal/injection.dart';
import 'package:smart_vision_journal/main.dart';
import 'package:smart_vision_journal/routes/app_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('end-to-end add note', (WidgetTester tester) async {
    // Initialize app dependencies.
    await dotenv.load();
    await init();

    // Clear any leftover notes so test is repeatable.
    try {
      final isar = sl<Isar>();
      await isar.writeTxn(() async {
        await isar.noteSchemas.clear();
      });
    } catch (_) {
      // If Isar isn't ready yet, ignore.
    }

    final appRouter = AppRouter();
    await tester.pumpWidget(MyApp(appRouter: appRouter));
    await tester.pumpAndSettle();

    // Ensure we begin with an empty list.
    expect(find.text('ยังไม่มีบันทึก'), findsOneWidget);

    // Open add note page.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Enter note text.
    await tester.enterText(find.byType(TextFormField), 'Integration test note');
    await tester.tap(find.text('Save note'));
    await tester.pumpAndSettle();

    // The note should show up in the list.
    expect(find.text('Integration test note'), findsOneWidget);
  });
}
