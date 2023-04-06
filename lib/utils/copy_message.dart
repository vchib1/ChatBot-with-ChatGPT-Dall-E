import 'exports.dart';

//o copy the message to clipboard
void copyText(String message,BuildContext context) async {
  await Clipboard.setData(ClipboardData(text: message)).then((value){
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text("Copied to clipboard"),
        ));
  });
}