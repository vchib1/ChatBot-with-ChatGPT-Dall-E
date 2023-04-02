class Message{
  final String role;
  final bool isImage;
  String content;

  Message({
    required this.role,
    required this.isImage,
    required this.content,
  });
}