import '../utils/exports.dart';

class SpeechProvider with ChangeNotifier{

  final SpeechToText speechToText = SpeechToText();

  Future<bool> toggleRecording(ScrollController controller,BuildContext context)async{
    final isAvailable = await speechToText.initialize();

    if(await speechToText.hasPermission){
      if(speechToText.isListening){
        speechToText.stop();
        return true;
      }
      if(isAvailable){
        speechToText.listen(onResult: (result) {
          if(result.finalResult) {
            context.read<MessageProvider>().sendPrompt(result.recognizedWords.trim(),controller,context);
          }
        });
      }
    }else{
      speechToText.initialize();
    }
    return isAvailable;
  }

}