import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_vision_journal/features/note/domain/entities/note.dart';
import 'package:smart_vision_journal/features/note/domain/usecases/add_note.dart';
import 'package:smart_vision_journal/features/note/domain/usecases/delete_note.dart';
import 'package:smart_vision_journal/features/note/domain/usecases/get_notes.dart';
import 'package:smart_vision_journal/features/note/domain/usecases/summarize_text.dart';
import 'package:smart_vision_journal/features/note/domain/usecases/update_note.dart';
import 'package:smart_vision_journal/features/note/presentation/bloc/note_event.dart';
import 'package:smart_vision_journal/features/note/presentation/bloc/note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final GetNotes getNotes;
  final AddNote addNote;
  final SummarizeText summarizeText;
  final UpdateNote updateNote;
  final DeleteNote deleteNote;

  NoteBloc(
    this.getNotes,
    this.addNote,
    this.summarizeText,
    this.updateNote,
    this.deleteNote,
  ) : super(const NoteState()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNoteEvent>(_onAddNote);
    on<SummarizeEvent>(_onSummarize);
    on<DeleteNoteEvent>(_onDelete);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    emit(state.copyWith(status: NoteStatus.loading, errorMessage: null));

    final result = await getNotes();
    result.fold(
      (failure) => emit(state.copyWith(
        status: NoteStatus.failure,
        errorMessage: failure.message,
      )),
      (notes) => emit(state.copyWith(
        status: NoteStatus.success,
        notes: notes,
      )),
    );
  }

  Future<void> _onAddNote(AddNoteEvent event, Emitter<NoteState> emit) async {
    emit(state.copyWith(status: NoteStatus.loading, errorMessage: null));

    final note = Note(id: DateTime.now().toIso8601String(), content: event.content);
    final result = await addNote(note);

    result.fold(
      (failure) => emit(state.copyWith(
        status: NoteStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => add(LoadNotes()),
    );
  }

  Future<void> _onSummarize(SummarizeEvent event, Emitter<NoteState> emit) async {
    emit(state.copyWith(status: NoteStatus.loading, errorMessage: null, deletedNoteId: null));

    final summarizeResult = await summarizeText(event.text);
    await summarizeResult.fold(
      (failure) async {
        emit(state.copyWith(
          status: NoteStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (summary) async {
        // Persist the summary for this note and refresh the list.
        final updateResult = await updateNote(
          Note(id: event.noteId, content: event.text, summary: summary),
        );
        updateResult.fold(
          (failure) => emit(state.copyWith(
            status: NoteStatus.failure,
            errorMessage: failure.message,
          )),
          (_) {
            emit(state.copyWith(
              status: NoteStatus.success,
              summary: summary,
              deletedNoteId: null,
            ));
            add(LoadNotes());
          },
        );
      },
    );
  }

  Future<void> _onDelete(DeleteNoteEvent event, Emitter<NoteState> emit) async {
    emit(state.copyWith(status: NoteStatus.loading, errorMessage: null, deletedNoteId: null));

    final deleteResult = await deleteNote(event.noteId);
    deleteResult.fold(
      (failure) => emit(state.copyWith(
        status: NoteStatus.failure,
        errorMessage: failure.message,
      )),
      (_) {
        emit(state.copyWith(
          status: NoteStatus.success,
          deletedNoteId: event.noteId,
        ));
        add(LoadNotes());
      },
    );
  }
}
