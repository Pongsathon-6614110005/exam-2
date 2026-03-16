import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class MlkitService {
  final textRecognizer = TextRecognizer();

  Future<String> extractText(InputImage image) async {
    final result = await textRecognizer.processImage(image);
    return result.text;
  }
}