import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:get/get.dart';

class OcrService extends GetxService {
 Future<String?> extractTextFromImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = TextRecognizer();
      final recognizedText = await textRecognizer.processImage(inputImage);
      
      String extractedText = recognizedText.text;
      await textRecognizer.close();
      
      if (extractedText.trim().isEmpty) {
        throw Exception('No text found in the image');
      }
      
      return extractedText.trim();
    } catch (e) {
      Get.snackbar(
        'OCR Error', 
        'Failed to extract text: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
      return null;
    }
  }
}