import 'package:dartz/dartz.dart';
import 'package:smart_vision_journal/core/error/failure.dart';
import 'package:smart_vision_journal/features/note/data/datasources/note_local_data_source.dart';
import 'package:smart_vision_journal/features/note/data/datasources/note_remote_data_source.dart';
import 'package:smart_vision_journal/features/note/data/datasources/summary_cache_data_source.dart';
import 'package:smart_vision_journal/features/note/data/models/note_model.dart';
import 'package:smart_vision_journal/features/note/domain/entities/note.dart';
import 'package:smart_vision_journal/features/note/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource local;
  final NoteRemoteDataSource remote;
  final SummaryCacheDataSource cache;

  NoteRepositoryImpl(this.local, this.remote, this.cache);

  @override
  Future<Either<Failure, Unit>> addNote(Note note) async {
    try {
      await local.addNote(NoteModel.fromEntity(note));
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getNotes() async {
    try {
      final models = await local.getNotes();
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> summarize(String text) async {
    try {
      final cacheKey = text.hashCode.toString();
      final cached = await cache.getSummary(cacheKey);
      if (cached != null && cached.isNotEmpty) {
        return Right(cached);
      }

      final result = await remote.summarize(text);
      if (result.isNotEmpty) {
        await cache.saveSummary(cacheKey, result);
      }

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateNote(Note note) async {
    try {
      await local.updateNote(NoteModel.fromEntity(note));
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNote(String id) async {
    try {
      await local.deleteNote(id);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
