import '../utils/exports.dart';
import 'package:http/http.dart' as http;


class ApiClass{

  //this is the main API which decides the prompt is a picture or not
  Future<String> mainApi(String prompt,ScrollController controller)async{

    //------------apikey is in constants file, you can get your own key from OpenAI's website----------
    //I was making simple chat bot with ChatGPT but thanks to Rivaan Ranawat
    //for this method to generate text and image
    try{
      final response = await http.post(Uri.parse("https://api.openai.com/v1/chat/completions"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $apiKey"
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [{
              "role": "assistant",
              "content": "is this asking you to generate or create or make an AI image, drawing, picture, photograph, painting or art? : $prompt. if yes then reply simply yes else no in lowercase"
            }]
          })
      );

      if(response.statusCode == 200){
        //prompt response
        final String content = jsonDecode(response.body)["choices"][0]["message"]["content"];
        content.trim();
        return content;
      }
      return "Something went wrong";
    }
    catch(e){
      return e.toString();
    }
  }

  //chat gpt api for basic text prompt
  Future<String> chatGptApi(String prompt,ScrollController controller)async{
    try{
      final response = await http.post(Uri.parse("https://api.openai.com/v1/chat/completions"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $apiKey"
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [{
              "role": "assistant",
              "content": prompt
            }]
          })
      );
      if(response.statusCode == 200){
        final String content = jsonDecode(response.body)["choices"][0]["message"]["content"];
        content.trim();
        return content;
      }
      return "Something went wrong";
    }
    catch(e){
      return e.toString();
    }
  }

  //Dall-E API for image generation
  Future<String> imageGenerationApi(String prompt,ScrollController controller)async{
    try{
      final response = await http.post(Uri.parse("https://api.openai.com/v1/images/generations"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $apiKey"
          },
          body: jsonEncode({
            "prompt": prompt,
            "n": 1,
            "size": "1024x1024"
          })
      );
      if(response.statusCode == 200){
        final String content = jsonDecode(response.body)["data"][0]["url"];
        content.trim();
        return content;
      }
      return "Something went wrong";
    }
    catch(e){
      return e.toString();
    }
  }
}