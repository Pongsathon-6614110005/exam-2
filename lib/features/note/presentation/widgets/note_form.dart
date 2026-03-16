import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_vision_journal/features/note/presentation/bloc/note_bloc.dart';
import 'package:smart_vision_journal/features/note/presentation/bloc/note_event.dart';

class AddNoteForm extends StatefulWidget {
  const AddNoteForm({super.key});

  @override
  State<AddNoteForm> createState() => _AddNoteFormState();
}

class _AddNoteFormState extends State<AddNoteForm> {
  final _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            validator: (v) => v!.isEmpty ? 'ห้ามว่าง' : null,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<NoteBloc>().add(AddNoteEvent(controller.text));
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}