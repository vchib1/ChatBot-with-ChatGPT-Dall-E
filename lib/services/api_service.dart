import 'dart:async';
import 'dart:convert';
import 'package:chatgptv1/constants/constants.dart';
import 'package:chatgptv1/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;

class ApiClass{

  //stream for stream builder (this is not the best way. but this is what i came up with)
  StreamController<List<Message>>? streamController = StreamController<List<Message>>();

  //to store user prompt and response from the API
  List<Message> messages = [];

  //auto scrolls the message list in listview to the bottom, when a response message is received from API and also when new prompt is requested
  scrollToBottom(ScrollController controller) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeOut,);
    });
  }

  //adding messages to list
  addMessages(String role,String content,bool isImage,ScrollController controller){
    messages.add(Message(role: role, content: content,isImage: isImage));
    streamController!.add(messages);
    scrollToBottom(controller);
  }

  //this is the main API which decides the prompt is a picture or not
  Future<String> mainApi(String prompt,ScrollController controller)async{

    //adds user prompt to messages
    addMessages("user", prompt, false, controller);

    //apikey is in constants file, you can get your own key from OpenAI's website
    //and this code is inspired from Rivaan Ranawat, I was stuck with this for so long
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
        print(content);
        //if the response is yes, then it will call the Dall-E image generation api, if no then simple the ChatGPTApi
        if(content == "yes"){
          final mainResponse = await imageGenerationApi(prompt,controller);
          return mainResponse;
        }else{
          final mainResponse = await chatGptApi(prompt,controller);
          return mainResponse;
        }
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
        addMessages("assistant", content, false, controller);
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
        addMessages("assistant", content, true, controller);
      }
      return "Something went wrong";
    }
    catch(e){
      return e.toString();
    }
  }

}