import '../utils/exports.dart';

class MessageProvider with ChangeNotifier{

  final String _user = "user";
  final String _bot = "bot";

  ApiClass apiClass = ApiClass();

  List<Message> _messages = [];
  List<Message> get messages => _messages; //getter to access _messages

  //clear messages
  void clearMessages(BuildContext context){
    _messages = [];
    notifyListeners();
  }

  //adding messages to list
  addMessages(String role,String content,bool isImage,ScrollController controller){
    messages.add(Message(role: role, content: content,isImage: isImage));
    scrollToBottom(controller);
  }

  //updating messages to list
  updateMessages(String role,String content,bool isImage,ScrollController controller){
    messages.last = Message(role: role, content: content,isImage: isImage);
    scrollToBottom(controller);
  }

  //sending prompt
  Future<void> sendPrompt(String prompt,ScrollController controller,BuildContext context)async{
    try{
      addMessages(_user, prompt, false, controller);
      notifyListeners();

      String result = await apiClass.mainApi(prompt, controller);

      if(result == "Something went wrong"){
        return;
      } else if(result == "yes"){
        final String responseImage = await apiClass.imageGenerationApi(prompt, controller);
        addMessages(_bot, responseImage, true, controller);
      }else{
        addMessages(_bot, "....", false, controller);
        notifyListeners();
        final String responseText = await apiClass.chatGptApi(prompt, controller);
        updateMessages(_bot, responseText, false, controller);
      }
    }catch(e){
      showSnackBar(e.toString(),context);
    }finally{
      notifyListeners();
    }
  }
}