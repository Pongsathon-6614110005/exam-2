import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_vision_journal/core/error/failure.dart';
import 'package:smart_vision_journal/features/note/domain/entities/note.dart';
import 'package:smart_vision_journal/features/note/domain/usecases/add_note.dart';
import 'package:smart_vision_journal/features/note/domain/usecases/delete_note.dart';
import 'package:smart_vision_journal/features/note/domain/usecases/get_notes.dart';
import 'package:smart_vision_journal/features/note/domain/usecases/summarize_text.dart';
import 'package:smart_vision_journal/features/note/domain/usecases/update_note.dart';
import 'package:smart_vision_journal/features/note/presentation/bloc/note_bloc.dart';
import 'package:smart_vision_journal/features/note/presentation/bloc/note_event.dart';
import 'package:smart_vision_journal/features/note/presentation/bloc/note_state.dart';

class FakeNote extends Fake implements Note {}

class MockGetNotes extends Mock implements GetNotes {}
class MockAddNote extends Mock implements AddNote {}
class MockSummarizeText extends Mock implements SummarizeText {}
class MockUpdateNote extends Mock implements UpdateNote {}
class MockDeleteNote extends Mock implements DeleteNote {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeNote());
  });

  late NoteBloc bloc;
  late MockGetNotes mockGetNotes;
  late MockAddNote mockAddNote;
  late MockSummarizeText mockSummarizeText;
  late MockUpdateNote mockUpdateNote;
  late MockDeleteNote mockDeleteNote;

  setUp(() {
    mockGetNotes = MockGetNotes();
    mockAddNote = MockAddNote();
    mockSummarizeText = MockSummarizeText();
    mockUpdateNote = MockUpdateNote();
    mockDeleteNote = MockDeleteNote();

    bloc = NoteBloc(
      mockGetNotes,
      mockAddNote,
      mockSummarizeText,
      mockUpdateNote,
      mockDeleteNote,
    );
  });

  test('initial state is NoteState.initial', () {
    expect(bloc.state.status, NoteStatus.initial);
    expect(bloc.state.notes, isEmpty);
  });

  test('LoadNotes emits loading then success with notes', () async {
    final notes = [Note(id: '1', content: 'hello')];
    when(() => mockGetNotes()).thenAnswer((_) async => Right<Failure, List<Note>>(notes));

    final expected = [
      predicate<NoteState>((state) => state.status == NoteStatus.loading),
      predicate<NoteState>((state) =>
          state.status == NoteStatus.success &&
          state.notes.length == 1 &&
          state.notes.first.id == '1'),
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

    bloc.add(LoadNotes());
  });

  test('AddNoteEvent calls AddNote and then reloads notes', () async {
    final note = Note(id: '1', content: 'hello');
    when(() => mockAddNote(any())).thenAnswer((_) async => const Right(unit));
    when(() => mockGetNotes()).thenAnswer((_) async => Right([note]));

    bloc.add(AddNoteEvent('hello'));

    await untilCalled(() => mockAddNote(any()));
    verify(() => mockAddNote(any())).called(1);
  });

  test('DeleteNoteEvent calls DeleteNote and then reloads notes', () async {
    when(() => mockDeleteNote(any())).thenAnswer((_) async => const Right(unit));
    when(() => mockGetNotes()).thenAnswer((_) async => const Right([]));

    bloc.add(DeleteNoteEvent(noteId: '1'));

    await untilCalled(() => mockDeleteNote(any()));
    verify(() => mockDeleteNote('1')).called(1);
  });
}
