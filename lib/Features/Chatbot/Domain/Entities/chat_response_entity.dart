import 'package:task_wizard/Features/Chatbot/Domain/Entities/response_data_entity.dart';

class ChatbotResponse {
  ChatbotResponse({
    required this.success,
    required this.message,
    required this.tasks,
    required this.timestamp,
    required this.action,
    required this.suggestions,
  });
  factory ChatbotResponse.fromJson(Map<String, dynamic> json) {
    List<TaskData> taskList = [];
    if (json['data'] != null) {
      final dataMap = json['data'] as Map<String, dynamic>;
      taskList = dataMap.values.map((item) => TaskData.fromList(item)).toList();
    }

    return ChatbotResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      tasks: taskList,
      timestamp: DateTime.parse(json['timestamp']),
      action: json['action'] ?? 'query',
      suggestions: List<String>.from(json['suggestions'] ?? []),
    );
  }
  final bool success;
  final String message;
  final List<TaskData> tasks;
  final DateTime timestamp;
  final String action;
  final List<String> suggestions;
}
