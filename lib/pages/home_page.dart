import '../utils/exports.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  //controller for text field
  final TextEditingController _textEditingController = TextEditingController();

  //controller for list view builder
  final ScrollController _scrollController = ScrollController();

  @override
  void initState(){
    super.initState();
  }

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
      context.read<ApiClass>().mainApi(_textEditingController.text.trim(),_scrollController);
      _textEditingController.clear(); //clear text field
    }
    FocusScope.of(context).unfocus(); //dismiss keyboard on submission
  }

  //method to access toggle recording
  void recordSpeech(){
    context.read<SpeechProvider>().toggleRecording(_scrollController,context);
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
            onSelected: (value) {
              if(value == 1){
                context.read<ApiClass>().clearMessages(context);
              }
              if(value == 2){
                context.read<ThemeProvider>().toggleTheme();
              }
            },
            icon: const Icon(Icons.more_vert,color: Colors.white,),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 1,
                child: Text("Clear Chat",style: TextStyle(color: Colors.white)),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Theme",style: TextStyle(color: Colors.white)),
              ),
            ]
          )
        ],
      ),
      body: Column(
        children: [
          //Chat Container
          Expanded(
              child: Consumer<ApiClass>(
                builder: (context, provider, child) {
                  if(provider.messages.isEmpty){
                    return Container(
                      alignment: Alignment.center,
                      child: Theme.of(context).primaryColor == primaryColor  ? Image.asset(lightLogo,scale: 1,width: 200) : Image.asset(darkLogo,scale: 1,width: 200),
                    );
                  }else{
                    return ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: provider.messages.length,
                      itemBuilder: (context, index){
                        final data = provider.messages[index];
                        //message tile for user and assistant with animations
                        if(data.role == "user"){
                          //user
                          return Align(
                            alignment: Alignment.topRight, //aligns user message tile to right
                            child: SlideInRight(
                              duration: const Duration(milliseconds: 300),
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: senderBorder,
                                ),
                                child: Text(data.content,style: Theme.of(context).primaryTextTheme.bodyMedium,), //user prompt message
                              ),
                            ),
                          );
                        }else{
                          //assistant
                          return Align(
                            alignment: Alignment.topLeft, //aligns assistant message tile to left
                            child: SlideInLeft(
                              duration: const Duration(milliseconds: 300),
                              child: GestureDetector(
                                onLongPress:  () => copyText(data.content), //copy message to clip board on long press
                                child: Container(
                                  height: data.isImage ? 250 : null, //if data.isImage then it the height and width is fixed to 250
                                  width: data.isImage ? 250 : null, //if not then the both are null, so it resizes according to its child
                                  padding: data.isImage ? const EdgeInsets.all(0) : const EdgeInsets.all(15),
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: receiverBorder,
                                  ),

                                  //if data.isImage is true then it shows cachedNetworkImage to show image. if false then shows text message
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
                                  )
                                      :
                                  data.content == "...." ? //if the data.content is "...." then it shows animated text until the actual message is updated
                                  //animated wavy animation
                                  AnimatedTextKit(
                                    totalRepeatCount: 5,
                                    animatedTexts: [
                                      WavyAnimatedText(data.content,textStyle: Theme.of(context).primaryTextTheme.bodyMedium,speed: const Duration(milliseconds: 300)),
                                    ],
                                    isRepeatingAnimation: true,
                                  )
                                      :
                                  //main message
                                  SelectableText(data.content,style: Theme.of(context).primaryTextTheme.bodyMedium,),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              )
          ),

          //Text Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                        hintText: "Message",
                        border: InputBorder.none
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => recordSpeech(),
                  icon: const Icon(Icons.mic)
                ),
                IconButton(
                  onPressed: () => sendPrompt(),
                  icon: const Icon(Icons.send)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}