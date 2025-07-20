import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_wizard/Features/Chatbot/Domain/Entities/chat_message_entity.dart';
import 'package:task_wizard/Features/Chatbot/Presentation/Controllers/Chatbot_controllers.dart';
import 'package:task_wizard/Features/Shared/Constants/Theme/my_colors.dart';
import 'package:task_wizard/Features/Shared/Constants/app_sizes.dart';
import 'package:task_wizard/Features/Shared/widgets/bottom_nav.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ChatbotController controller = Get.find<ChatbotController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: const CustomBottomNavBarFloating(currentPage: 2),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16),
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
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: message.isUser ? Colors.blue : MYColors.bgGreenColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message.message,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
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
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              suggestions.map((suggestion) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed:
                        () => controller.onSuggestionTap(context, suggestion),
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.blue.shade50,
                      foregroundColor: Colors.blue.shade800,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      suggestion,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (value) {
                      controller.sendMessage(value, context);
                    },
                  ),
                ),
                const SizedBox(width: 8),
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

                    child:
                        controller.isLoading.value
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
