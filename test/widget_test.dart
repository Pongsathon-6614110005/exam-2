import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_vision_journal/features/note/presentation/widgets/note_form.dart';

void main() {
  testWidgets('AddNoteForm shows validation error when empty', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AddNoteForm(),
        ),
      ),
    );

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('ห้ามว่าง'), findsOneWidget);
  });
}
