import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_wizard/Features/Chatbot/Presentation/Controllers/chatbot_controllers.dart';
import 'package:task_wizard/Features/Chatbot/Domain/Entities/response_data_entity.dart';

class TaskReviewScreen extends StatelessWidget {
  const TaskReviewScreen({super.key, required this.tasks});
  final List<TaskData> tasks;

  @override
  Widget build(BuildContext context) {
    final ChatbotController controller = Get.find<ChatbotController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Tasks'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          task.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.date_range, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${task.startDate.day}/${task.startDate.month}/${task.startDate.year} - ${task.endDate.day}/${task.endDate.month}/${task.endDate.year}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.repeat, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              task.recurrence,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.saveTasksToFirebase(
                        context,
                        List<TaskData>.from(tasks),
                      );
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Accept Tasks'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
