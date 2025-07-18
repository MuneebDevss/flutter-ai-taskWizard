
import 'package:task_wizard/Features/Shared/Data/Entities/normal_task_entity.dart';

abstract class TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final NormalTask task;
  AddTaskEvent(this.task);
}

class GetTaskEvent extends TaskEvent {
  final String id;
  GetTaskEvent(this.id);
}

class GetAllTasksEvent extends TaskEvent {}

class UpdateTaskEvent extends TaskEvent {
  final String id;
  final NormalTask task;
  UpdateTaskEvent(this.id, this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final String id;
  DeleteTaskEvent(this.id);
}


