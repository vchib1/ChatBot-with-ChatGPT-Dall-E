import 'package:chatgptv1/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SpeechProvider with ChangeNotifier{

  final speechToText = SpeechToText();

  Future<void> onResult(SpeechRecognitionResult result,ScrollController controller,BuildContext context) async {
    if(result.finalResult){
      context.read<ApiClass>().mainApi(result.recognizedWords.trim(),controller);
    }
    notifyListeners();
  }

  Future<bool> toggleRecording(ScrollController controller,BuildContext context)async{
    final isAvailable = await speechToText.initialize();

    if(await speechToText.hasPermission){
      if(speechToText.isListening){
        speechToText.stop();
        return true;
      }
      if(isAvailable){
        speechToText.listen(onResult: (result) => onResult(result,controller,context));
      }
    }else{
      speechToText.initialize();
    }

    return isAvailable;
  }

}