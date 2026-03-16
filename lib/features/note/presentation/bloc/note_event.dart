abstract class NoteEvent {}

class LoadNotes extends NoteEvent {}

class AddNoteEvent extends NoteEvent {
  final String content;
  AddNoteEvent(this.content);
}

class SummarizeEvent extends NoteEvent {
  final String noteId;
  final String text;

  SummarizeEvent({required this.noteId, required this.text});
}

class DeleteNoteEvent extends NoteEvent {
  final String noteId;

  DeleteNoteEvent({required this.noteId});
}