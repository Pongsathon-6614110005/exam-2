import 'package:smart_vision_journal/services/llm_service.dart';

class NoteRemoteDataSource {
  final LlmService llmService;

  NoteRemoteDataSource(this.llmService);

  Future<String> summarize(String text) async {
    return await llmService.summarize(text);
  }
}