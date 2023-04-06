import '../../utils/exports.dart';

AppBar appBar(BuildContext context) {
  return AppBar(
    //svg image for OpenAI logo
    title: SvgPicture.asset('assets/open_ai.svg',color: Colors.white,height: 25,),
    actions: [
      PopupMenuButton(
          onSelected: (value) {
            if(value == 1){
              context.read<MessageProvider>().clearMessages(context);
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
              child: Text("Switch theme",style: TextStyle(color: Colors.white)),
            ),
          ]
      )
    ],
  );
}
