class Message{
  final String role;
  final bool isImage;
  final String content;

  const Message({
    required this.role,
    required this.isImage,
    required this.content,
  });
}