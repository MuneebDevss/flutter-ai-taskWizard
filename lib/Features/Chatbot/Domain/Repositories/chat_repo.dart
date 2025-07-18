import 'package:dio/dio.dart';
import 'package:task_wizard/Features/Chatbot/Domain/Entities/chat_req_entity.dart';
import 'package:task_wizard/Features/Chatbot/Domain/Entities/chat_response_entity.dart';

class ChatbotRepository {
  final Dio _dio = Dio();
  final String baseUrl = 'http://localhost:3000/api/chat';

  Future<ChatbotResponse> sendMessage(ChatbotRequest request) async {
    try {
      final response = await _dio.post(
        '$baseUrl/chat',
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      return ChatbotResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to send message: ${e.message}');
    }
  }
}