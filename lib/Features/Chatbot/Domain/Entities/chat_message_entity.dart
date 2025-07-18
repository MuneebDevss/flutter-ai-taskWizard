import 'package:task_wizard/Features/Chatbot/Domain/Entities/response_data_entity.dart';

class ChatMessage {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final String? action;
  final List<String>? suggestions;
  final List<TaskData>? tasks;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.action,
    this.suggestions,
    this.tasks,
  });

  factory ChatMessage.user(String message) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      isUser: true,
      timestamp: DateTime.now(),
    );
  }

  factory ChatMessage.bot({
    required String message,
    String? action,
    List<String>? suggestions,
    List<TaskData>? tasks,
  }) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      isUser: false,
      timestamp: DateTime.now(),
      action: action,
      suggestions: suggestions,
      tasks: tasks,
    );
  }
}