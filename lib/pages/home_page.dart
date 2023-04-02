import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatgptv1/constants/constants.dart';
import 'package:chatgptv1/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/chat_model.dart';
import '../utils/view_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  //instance of ApiClass to access its methods
  ApiClass apiClass = ApiClass();

  //controller for text field
  final TextEditingController _textEditingController = TextEditingController();
  //controller for list view builder
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _scrollController.dispose();
  }

  //Sends prompt request to ChatGPT
  void sendPrompt(){
    if(_textEditingController.text.isNotEmpty){
      //calling mainApi with prompt text and scroll controller
      apiClass.mainApi(_textEditingController.text.trim(),_scrollController);

      //clear text field on submission
      _textEditingController.clear();
    }
    //dismiss keyboard on submission
    FocusScope.of(context).unfocus();
  }

  //on long press copy the message to clipboard
  void copyText(String message) async {
    await Clipboard.setData(ClipboardData(text: message)).then((value){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text("Copied to clipboard"),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //svg image for OpenAI logo
        title: SvgPicture.asset('assets/open_ai.svg',color: Colors.white,height: 25,),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert,color: Colors.white,),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: GestureDetector(
                      onTap: (){
                        //clear messages list
                        setState(() {
                          apiClass.messages.clear();
                          apiClass.streamController!.add(apiClass.messages);
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Clear Chat",style: TextStyle(color: Colors.white))),
                ),
              ];
            },
          )
        ],
      ),
      body: Column(
        children: [
          //Chat Container
          Expanded(
              child: StreamBuilder<List<Message>>(
                //stream watching list of messages
                stream: apiClass.streamController!.stream,
                builder: (context, snapshot) {
                  //if snapshot is empty or does not have data then it shows chat gpt logo
                  if(!snapshot.hasData || snapshot.data!.isEmpty){
                    return Container(
                      alignment: Alignment.center,
                      child: Image.asset("assets/chatgpt.png",scale: 1,width: 200),
                    );
                  }
                  //else shows list view of messages
                  return ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: apiClass.messages.length,
                    itemBuilder: (context, index){
                      final data = snapshot.data![index];
                      //message tile for user and assistant with animations
                      if(data.role == "user"){
                        //user
                        return Align(
                          alignment: Alignment.topRight,
                          child: SlideInRight(
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: senderBorder,
                              ),
                              child: Text(data.content,style: const TextStyle(fontSize: 16),),
                            ),
                          ),
                        );
                      }else{
                        //assistant
                        return Align(
                          alignment: Alignment.topLeft,
                          child: SlideInLeft(
                            duration: const Duration(milliseconds: 300),
                            child: GestureDetector(
                              onLongPress:  () => copyText(data.content),
                              child: Container(
                                height: data.isImage ? 250 : null,
                                width: data.isImage ? 250 : null,
                                padding: data.isImage ? const EdgeInsets.all(0) : const EdgeInsets.all(15),
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: receiverBorder,
                                ),
                                child: data.isImage ?
                                GestureDetector(
                                    onTap: ()=> viewImage(context, data.content),
                                    child: CachedNetworkImage(
                                      imageUrl: data.content,
                                      fit: BoxFit.cover,
                                      maxHeightDiskCache: 250,
                                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                          child: CircularProgressIndicator(
                                            value: downloadProgress.progress,color: Colors.white,
                                          )
                                      ),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    )
                                ) : Text(data.content,style: const TextStyle(fontSize: 16),),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              )
          ),

          //Text Field
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: TextField(
              onSubmitted: (value) => sendPrompt(),
              controller: _textEditingController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15.0),
                  hintText: "Type here",
                  hintStyle: const TextStyle(fontSize: 16,color: Colors.white),
                  fillColor: Theme.of(context).colorScheme.primary,
                  filled: true,
                  suffixIcon: IconButton(
                    onPressed: () => sendPrompt(),
                    icon: const Icon(Icons.send,color: Colors.white,),
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}