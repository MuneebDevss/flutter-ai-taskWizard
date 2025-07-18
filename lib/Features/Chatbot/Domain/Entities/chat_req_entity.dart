class ChatbotRequest {
  final String message;
  final String userId;

  ChatbotRequest({
    required this.message,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
    };
  }
}