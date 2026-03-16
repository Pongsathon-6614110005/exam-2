import 'package:smart_vision_journal/features/note/domain/entities/note.dart';

class NoteModel {
  final String id;
  final String content;
  final String? summary;

  NoteModel({required this.id, required this.content, this.summary});

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      content: json['content'] as String,
      summary: json['summary'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'summary': summary,
      };

  Note toEntity() {
    return Note(id: id, content: content, summary: summary);
  }

  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      content: note.content,
      summary: note.summary,
    );
  }
}