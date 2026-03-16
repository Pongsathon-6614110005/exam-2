import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_vision_journal/features/note/presentation/widgets/note_form.dart';

void main() {
  testWidgets('shows validation error when note text is empty', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AddNoteForm(),
        ),
      ),
    );

    // Tap save without entering any text.
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Expect to see the validation message.
    expect(find.text('ห้ามว่าง'), findsOneWidget);
  });
}
