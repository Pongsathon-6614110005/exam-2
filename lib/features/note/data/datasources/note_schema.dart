import 'package:isar/isar.dart';
part 'note_schema.g.dart';

@collection
class NoteSchema {
  Id id = Isar.autoIncrement;
  @Index()
  late String uid;
  late String content;
  String? summary;
}