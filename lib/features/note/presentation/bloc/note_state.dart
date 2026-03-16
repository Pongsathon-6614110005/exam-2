import 'package:smart_vision_journal/features/note/domain/entities/note.dart';

enum NoteStatus { initial, loading, success, failure }

class NoteState {
  final NoteStatus status;
  final List<Note> notes;
  final String? summary;
  final String? deletedNoteId;
  final String? errorMessage;

  const NoteState({
    this.status = NoteStatus.initial,
    this.notes = const [],
    this.summary,
    this.deletedNoteId,
    this.errorMessage,
  });

  NoteState copyWith({
    NoteStatus? status,
    List<Note>? notes,
    String? summary,
    String? deletedNoteId,
    String? errorMessage,
  }) {
    return NoteState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      summary: summary ?? this.summary,
      deletedNoteId: deletedNoteId ?? this.deletedNoteId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
