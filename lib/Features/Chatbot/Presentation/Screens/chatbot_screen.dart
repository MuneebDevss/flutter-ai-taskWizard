import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_wizard/Features/Chatbot/Domain/Entities/chat_message_entity.dart';
import '../Controllers/chatbot_controllers.dart';

class ChatbotScreen extends StatelessWidget {
  final ChatbotController controller = Get.put(ChatbotController());

  ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Assistant'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                reverse: true,
                padding: EdgeInsets.all(16),
                itemCount:
                    controller.messages.length +
                    (controller.isTyping.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (controller.isTyping.value && index == 0) {
                    return _buildTypingIndicator();
                  }

                  final messageIndex =
                      controller.isTyping.value ? index - 1 : index;
                  final message =
                      controller.messages.reversed.toList()[messageIndex];

                  return _buildMessageBubble(message);
                },
              ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 300),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: message.isUser ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message.message,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
          if (!message.isUser && message.suggestions != null)
            _buildSuggestions(message.suggestions!),
        ],
      ),
    );
  }

  Widget _buildSuggestions(List<String> suggestions) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed:
                  () => controller.onSuggestionTap(context, suggestions[index]),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[50],
                foregroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(suggestions[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                ),
                SizedBox(width: 8),
                Text('Typing...'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Builder(
      builder:
          (context) => Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (value) {
                      controller.sendMessage(value, context);
                    },
                  ),
                ),
                SizedBox(width: 8),
                Obx(
                  () => FloatingActionButton(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : () => controller.sendMessage(
                              controller.messageController.text,
                              context,
                            ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    child:
                        controller.isLoading.value
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
