import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_vision_journal/features/note/presentation/bloc/note_bloc.dart';
import 'package:smart_vision_journal/features/note/presentation/bloc/note_state.dart';
import 'package:smart_vision_journal/routes/app_router.dart';

class NoteList extends StatelessWidget {
  const NoteList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        if (state.status == NoteStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == NoteStatus.failure) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        }

        if (state.notes.isEmpty) {
          return const Center(child: Text('ยังไม่มีบันทึก')); // Thai for "No notes yet"
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: ListView.builder(
            key: ValueKey(state.notes.length),
            itemCount: state.notes.length,
            itemBuilder: (_, i) {
              final note = state.notes[i];
              return ListTile(
                title: Hero(
                  tag: 'note-${note.id}',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      note.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                subtitle: note.summary != null ? Text(note.summary!) : null,
                onTap: () {
                  context.router.push(NoteDetailRoute(
                    id: note.id,
                    content: note.content,
                    summary: note.summary,
                  ));
                },
              );
            },
          ),
        );
      },
    );
  }
}
