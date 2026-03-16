import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_vision_journal/core/error/failure.dart';
import 'package:smart_vision_journal/features/note/domain/entities/note.dart';
import 'package:smart_vision_journal/features/note/domain/repositories/note_repository.dart';
import 'package:smart_vision_journal/features/note/domain/usecases/add_note.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

void main() {
  late AddNote usecase;
  late MockNoteRepository repository;

  setUp(() {
    repository = MockNoteRepository();
    usecase = AddNote(repository);
  });

  test('should forward add note to repository and return success', () async {
    final note = Note(id: '1', content: 'hello');

    when(() => repository.addNote(note))
        .thenAnswer((_) async => const Right(unit));

    final result = await usecase(note);

    expect(result, const Right(unit));
    verify(() => repository.addNote(note)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should forward failure from repository', () async {
    final note = Note(id: '2', content: 'hi');
    final failure = CacheFailure('oops');

    when(() => repository.addNote(note))
        .thenAnswer((_) async => Left(failure));

    final result = await usecase(note);

    expect(result, Left(failure));
    verify(() => repository.addNote(note)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
