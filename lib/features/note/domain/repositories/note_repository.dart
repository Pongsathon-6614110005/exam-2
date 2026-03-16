import 'package:dartz/dartz.dart';
import 'package:smart_vision_journal/core/error/failure.dart';
import 'package:smart_vision_journal/features/note/domain/entities/note.dart';

abstract class NoteRepository {
  Future<Either<Failure, List<Note>>> getNotes();
  Future<Either<Failure, Unit>> addNote(Note note);
  Future<Either<Failure, Unit>> updateNote(Note note);
  Future<Either<Failure, Unit>> deleteNote(String id);
  Future<Either<Failure, String>> summarize(String text);
}