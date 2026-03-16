import 'package:dartz/dartz.dart';
import 'package:smart_vision_journal/core/error/failure.dart';
import 'package:smart_vision_journal/features/note/domain/repositories/note_repository.dart';

class SummarizeText {
  final NoteRepository repository;
  SummarizeText(this.repository);

  Future<Either<Failure, String>> call(String text) async {
    return await repository.summarize(text);
  }
}
