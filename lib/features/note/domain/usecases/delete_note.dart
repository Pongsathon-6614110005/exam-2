import 'package:dartz/dartz.dart';
import 'package:smart_vision_journal/core/error/failure.dart';
import 'package:smart_vision_journal/features/note/domain/repositories/note_repository.dart';

class DeleteNote {
  final NoteRepository repository;
  DeleteNote(this.repository);

  Future<Either<Failure, Unit>> call(String id) async {
    return await repository.deleteNote(id);
  }
}
