import 'package:dio/dio.dart';
import 'package:task_wizard/Features/Chatbot/Domain/Entities/chat_req_entity.dart';
import 'package:task_wizard/Features/Chatbot/Domain/Entities/chat_response_entity.dart';

class ChatbotRepository {
  // Replace with your Render URL

  ChatbotRepository() {
    _dio.interceptors.add(
      LogInterceptor(responseBody: true, requestBody: true),
    );
  }
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 12),
    ),
  );
  final String baseUrl = 'https://ai-taskpilot-api-3vbu.onrender.com/api';

  Future<ChatbotResponse> sendMessage(ChatbotRequest request) async {
    try {
      final response = await _dio.post(
        '$baseUrl/chat',
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return ChatbotResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('Dio error: ${e.type}, ${e.message}, ${e.error}');
      if (e.response != null) {
        print('Response data: ${e.response?.data}');
      }
      throw Exception('Failed to send message: ${e.message}');
    }
  }
}
