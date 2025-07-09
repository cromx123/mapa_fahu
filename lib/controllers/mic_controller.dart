// File: maps_fahu/lib/controllers/mic_controller.dart
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:maps_fahu/controllers/campus_map_controller.dart';

class MicController extends ChangeNotifier {
  final CampusMapController controller;

  final TextEditingController searchController = TextEditingController();
  final SpeechToText speechToText = SpeechToText();

  bool isListening = false;

  MicController(this.controller);

  Future<void> startListening() async {
    bool available = await speechToText.initialize(
      onStatus: (status) {
        if (status == 'notListening') {
          isListening = false;
        } else {
          isListening = true;
        }
        notifyListeners();
      },
      onError: (error) {
        print('Error: $error');
        isListening = false;
        notifyListeners();
      },
    );

    if (available) {
      await speechToText.listen(
        onResult: (val) {
          searchController.text = val.recognizedWords;
          notifyListeners();

          if (val.finalResult) {
            controller.buscarLugar(val.recognizedWords);
            stopListening();
          }
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 5),
        localeId: 'es_CL',
        cancelOnError: true,
        partialResults: false,
      );
      isListening = true;
      notifyListeners();
    } else {
      print('Speech recognition not available');
      isListening = false;
      notifyListeners();
    }
  }

  void stopListening() {
    speechToText.stop();
    isListening = false;
    notifyListeners();
  }
}
