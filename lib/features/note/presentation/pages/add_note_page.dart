import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_vision_journal/features/note/presentation/bloc/note_bloc.dart';
import 'package:smart_vision_journal/features/note/presentation/bloc/note_event.dart';

@RoutePage()
class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isScanning = false;

  Future<void> _pickImageAndExtractText(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked == null) return;

    setState(() {
      _isScanning = true;
    });

    final inputImage = InputImage.fromFilePath(picked.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      _controller.text = recognizedText.text;
    } finally {
      await textRecognizer.close();
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    context.read<NoteBloc>().add(AddNoteEvent(_controller.text.trim()));
    context.router.popForced();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _controller,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Text or scanned result',
                ),
                validator: (v) => (v ?? '').trim().isEmpty ? 'ห้ามว่าง' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.photo_camera),
                      label: const Text('Scan from camera'),
                      onPressed: _isScanning
                          ? null
                          : () => _pickImageAndExtractText(ImageSource.camera),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Select image'),
                      onPressed: _isScanning
                          ? null
                          : () => _pickImageAndExtractText(ImageSource.gallery),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isScanning ? 0.5 : 1.0,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save note'),
                  onPressed: _isScanning ? null : _onSave,
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                ),
              ),
              if (_isScanning) ...[
                const SizedBox(height: 16),
                const Center(child: CircularProgressIndicator()),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
