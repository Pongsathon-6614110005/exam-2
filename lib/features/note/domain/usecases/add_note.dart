import 'package:dartz/dartz.dart';
import 'package:smart_vision_journal/core/error/failure.dart';
import 'package:smart_vision_journal/features/note/domain/entities/note.dart';
import 'package:smart_vision_journal/features/note/domain/repositories/note_repository.dart';

class AddNote {
  final NoteRepository repository;
  AddNote(this.repository);

  Future<Either<Failure, Unit>> call(Note note) async {
    return await repository.addNote(note);
  }
}