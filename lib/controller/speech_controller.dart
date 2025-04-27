// lib/controllers/speech_controller.dart
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechController extends GetxController {
  final SpeechToText _speechToText = SpeechToText();
  final RxBool _speechEnabled = false.obs;
  final RxBool _isListening = false.obs;
  final RxString _recognizedText = ''.obs;

  bool get isListening => _isListening.value;
  bool get speechEnabled => _speechEnabled.value;
   RxString get recognizedTextRx => _recognizedText;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechEnabled.value = await _speechToText.initialize();
    if (!_speechEnabled.value) {
      Get.snackbar(
        'Speech Not Available',
        'Speech recognition could not be initialized',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> checkMicrophonePermission() async {
    final status = await Permission.microphone.status;
    if (status.isDenied) {
      await Permission.microphone.request();
    }
  }

  Future<void> startListening() async {
    if (!_speechEnabled.value) return;
    
    await checkMicrophonePermission();
    _isListening.value = true;
    _recognizedText.value = '';
    
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      localeId: "en_US",
      cancelOnError: true,
      partialResults: true,
    );
  }

  Future<void> stopListening() async {
    _isListening.value = false;
    await _speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _recognizedText.value = result.recognizedWords;
    if (result.finalResult) {
      stopListening();
    }
  }

  void clearRecognizedText() {
    _recognizedText.value = '';
  }

  @override
  void onClose() {
    _speechToText.stop();
    super.onClose();
  }
}