import 'package:isar/isar.dart';
import 'package:smart_vision_journal/features/note/data/datasources/note_schema.dart';
import 'package:smart_vision_journal/features/note/data/models/note_model.dart';

abstract class NoteLocalDataSource {
  Future<List<NoteModel>> getNotes();
  Future<void> addNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(String id);
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final Isar isar;

  NoteLocalDataSourceImpl(this.isar);

  @override
  Future<void> addNote(NoteModel note) async {
    final data = NoteSchema()
      ..uid = note.id
      ..content = note.content
      ..summary = note.summary;

    await isar.writeTxn(() async {
      await isar.noteSchemas.put(data);
    });
  }

  @override
  Future<List<NoteModel>> getNotes() async {
    final result = await isar.noteSchemas.where().findAll();
    return result
        .map((e) => NoteModel(id: e.uid, content: e.content, summary: e.summary))
        .toList();
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    final existing = await isar.noteSchemas.filter().uidEqualTo(note.id).findFirst();
    if (existing == null) return;

    await isar.writeTxn(() async {
      existing.content = note.content;
      existing.summary = note.summary;
      await isar.noteSchemas.put(existing);
    });
  }

  @override
  Future<void> deleteNote(String id) async {
    final existing = await isar.noteSchemas.filter().uidEqualTo(id).findFirst();
    if (existing == null) return;

    await isar.writeTxn(() async {
      await isar.noteSchemas.delete(existing.id);
    });
  }
}