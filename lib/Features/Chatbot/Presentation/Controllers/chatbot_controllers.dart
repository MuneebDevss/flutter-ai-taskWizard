import 'package:flutter/material.dart'
    show BuildContext, Colors, TextEditingController;
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:task_wizard/Features/Chatbot/Domain/Entities/chat_message_entity.dart';
import 'package:task_wizard/Features/Chatbot/Domain/Entities/chat_req_entity.dart';
import 'package:task_wizard/Features/Chatbot/Domain/Entities/response_data_entity.dart'
    show TaskData;
// import 'package:task_wizard/Features/Chatbot/Domain/Entities/response_data_entity.dart'
//     show TaskData;
import 'package:task_wizard/Features/Chatbot/Domain/Repositories/chat_repo.dart';
import 'package:task_wizard/Features/Chatbot/Presentation/Screens/task_review_screen.dart';
import 'package:task_wizard/Features/CreateTask/Domain/task_repos.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/collaboration_enitiy.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/normal_task_entity.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/recurrence_entity.dart';
import 'package:task_wizard/Features/Shared/Utils/helping_functions.dart';
import 'package:task_wizard/depencyInjection.dart';

class ChatbotController extends GetxController {
  final ChatbotRepository _repository = ChatbotRepository();
  final TaskRepos _taskRepository = injector<TaskRepos>();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isTyping = false.obs;
  final TextEditingController messageController = TextEditingController();

  late final String userId; // Replace with actual user ID

  @override
  void onInit() {
    super.onInit();
    userId = HelpingFunctions.getCurrentUser()?.uid ?? '';
    _addWelcomeMessage();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage.bot(
      message: "Hello! I'm your AI assistant. How can I help you today?",
      suggestions: [
        'Create a daily task',
        'Schedule a meeting',
        'Set a reminder',
        'Plan my week',
      ],
    );
    messages.add(welcomeMessage);
  }

  Future<void> sendMessage(String message, BuildContext context) async {
    if (message.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage.user(message);
    messages.add(userMessage);
    messageController.clear();

    // Show typing indicator
    isTyping.value = true;
    isLoading.value = true;

    try {
      final request = ChatbotRequest(message: message, userId: userId);

      final response = await _repository.sendMessage(request);

      // Create bot message
      final botMessage = ChatMessage.bot(
        message: response.message,
        action: response.action,
        suggestions: response.suggestions,
        tasks: response.tasks,
      );

      messages.add(botMessage);

      // Handle create_task action
      if (response.action == 'create_task' && response.tasks.isNotEmpty) {
        _handleCreateTaskAction(context, response.tasks);
      }
    } catch (e) {
      final errorMessage = ChatMessage.bot(
        message: 'Sorry, I encountered an error. Please try again.',
        suggestions: ['Try again', 'Contact support'],
      );
      messages.add(errorMessage);
      HelpingFunctions.showRejectedStateSnackbar(
        context,
        message + e.toString(),
      );
    } finally {
      isLoading.value = false;
      isTyping.value = false;
    }
  }

  void _handleCreateTaskAction(BuildContext context, List<TaskData> tasks) {
    if (context.mounted) {
      HelpingFunctions.pushOnePage(context, TaskReviewScreen(tasks: tasks));
    }
  }

  Future<void> saveTasksToFirebase(
    BuildContext context,
    List<TaskData> tasks,
  ) async {
    try {
      for (TaskData task in tasks) {
        // Convert recurrence string to Recurrence object if needed
        Recurrence? recurrenceObj;
        if (task.recurrence.isNotEmpty) {
          // You need to implement a proper parser for your recurrence string
          // Here is a placeholder example:
          recurrenceObj = Recurrence.fromMap({
            'type': task.recurrence,
            'interval': 1,
            'days_of_week': [],
            'end_date': null,
          });
        }

        // Construct NormalTask (fill in other fields as needed)
        final normalTask = NormalTask(
          id: '',
          title: task.title,
          description: task.description,
          category: task.category ?? '',
          priority: task.priority ?? 'None',
          startDate: task.startDate,
          duration: 0, // Set appropriate duration
          status: '', // Set appropriate status
          notes: '', // Set appropriate notes
          recurrence: recurrenceObj!,
          reminders: [], // Add reminders if needed
          collaboration:
              Collaboration()
                ..isShared = false
                ..sharedWith = [],
        );

        // Save task using repository (adjust parameters as per your repository)
        await _taskRepository.addTask(normalTask);
      }
      if (context.mounted) {
        HelpingFunctions.showConfirmedStateSnackbar(
          context,
          "Tasks saved successfully!",
        );
      }

      // Add confirmation message
      final confirmationMessage = ChatMessage.bot(
        message: "Great! I've saved ${tasks.length} task(s) for you.",
        suggestions: ["What's next?", "Show my tasks", "Create another task"],
      );
      messages.add(confirmationMessage);
    } catch (e) {
      if (context.mounted) {
        HelpingFunctions.showRejectedStateSnackbar(
          context,
          "Failed to save tasks: ${e.toString()}",
        );
      }
    }
  }

  void onSuggestionTap(BuildContext context, String suggestion) {
    sendMessage(suggestion, context);
  }
}
