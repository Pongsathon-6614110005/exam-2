import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_vision_journal/core/error/failure.dart';
import 'package:smart_vision_journal/features/note/domain/repositories/note_repository.dart';
import 'package:smart_vision_journal/features/note/domain/usecases/delete_note.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

void main() {
  late DeleteNote usecase;
  late MockNoteRepository repository;

  setUp(() {
    repository = MockNoteRepository();
    usecase = DeleteNote(repository);
  });

  test('should forward delete note to repository and return success', () async {
    const noteId = 'abc';

    when(() => repository.deleteNote(noteId))
        .thenAnswer((_) async => const Right(unit));

    final result = await usecase(noteId);

    expect(result, const Right(unit));
    verify(() => repository.deleteNote(noteId)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should forward failure from repository', () async {
    const noteId = 'xyz';
    final failure = ServerFailure('server is down');

    when(() => repository.deleteNote(noteId))
        .thenAnswer((_) async => Left(failure));

    final result = await usecase(noteId);

    expect(result, Left(failure));
    verify(() => repository.deleteNote(noteId)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
