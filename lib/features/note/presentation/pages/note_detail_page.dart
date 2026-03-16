import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_vision_journal/features/note/domain/entities/note.dart';
import 'package:smart_vision_journal/features/note/presentation/bloc/note_bloc.dart';
import 'package:smart_vision_journal/features/note/presentation/bloc/note_event.dart';
import 'package:smart_vision_journal/features/note/presentation/bloc/note_state.dart';

@RoutePage()
class NoteDetailPage extends StatelessWidget {
  final String id;
  final String content;
  final String? summary;

  const NoteDetailPage({
    super.key,
    required this.id,
    required this.content,
    this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteBloc, NoteState>(
      listener: (context, state) {
        if (state.status == NoteStatus.success && state.deletedNoteId == id) {
          context.router.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Note Details'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete note',
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Delete note'),
                      content: const Text(
                        'Are you sure you want to delete this note?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );

                if (confirmed == true) {
                  context.read<NoteBloc>().add(DeleteNoteEvent(noteId: id));
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'note-$id',
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    content,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Summarize with AI'),
                onPressed: () {
                  context.read<NoteBloc>().add(
                    SummarizeEvent(noteId: id, text: content),
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<NoteBloc, NoteState>(
                builder: (context, state) {
                  if (state.status == NoteStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final note = state.notes.firstWhere(
                    (n) => n.id == id,
                    orElse: () => Note(id: id, content: content),
                  );
                  final rawSummary = note.summary ?? state.summary ?? summary;
                  final displaySummary = rawSummary?.trim();
                  if (displaySummary == null || displaySummary.isEmpty) {
                    return const Text(
                      'ยังไม่มีสรุป',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    );
                  }

                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: 1.0,
                    child: Text(
                      displaySummary,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
