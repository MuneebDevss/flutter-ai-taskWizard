// task_repository.dart

import 'package:task_wizard/Features/Shared/Data/Entities/normal_task_entity.dart';

abstract interface class TaskRemoteDataSource {
  Future<NormalTask> addTask(NormalTask task);
  Future<NormalTask?> getTask(String id);
  Future<List<NormalTask>> getTasksByCategory(String category);
  Future<void> saveAllTasks(List<NormalTask> tasks);
  Future<void> clearAllTasks();
  Future<List<NormalTask>> getAllTasks();
  Future<NormalTask> updateTask(String id, NormalTask task);
  Future<void> deleteTask(String id);
  Future<List<NormalTask>> getTasksByDate(DateTime date);
}
