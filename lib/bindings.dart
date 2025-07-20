import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:task_wizard/Features/Chatbot/Presentation/Controllers/Chatbot_controllers.dart';

class ChatbotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatbotController());
  }
}
