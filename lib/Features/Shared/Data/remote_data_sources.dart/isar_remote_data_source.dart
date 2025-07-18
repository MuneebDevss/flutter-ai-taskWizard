import 'package:isar/isar.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/normal_task_entity.dart';
import 'package:task_wizard/Features/Shared/Data/remote_data_sources.dart/task_remote_data_source.dart';


class IsarTaskRepository implements TaskRemoteDataSource {
  final Isar isar;

  IsarTaskRepository(this.isar);
  
  @override
  Future<void> saveAllTasks(List<NormalTask> tasks) async {
    await isar.writeTxn(() async {
      await isar.normalTasks.putAll(tasks);
    });
  }

  @override
  Future<List<NormalTask>> getAllTasks() async {
    return await isar.normalTasks.where().findAll();
  }

  @override
  Future<List<NormalTask>> getTasksByCategory(String category) async {
    return await isar.normalTasks
        .filter()
        .categoryEqualTo(category)
        .sortByStartDate()
        .findAll();
  }

  @override
  Future<List<NormalTask>> getTasksByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return await isar.normalTasks
        .filter()
        .startDateBetween(startOfDay, endOfDay)
        .sortByStartDate()
        .findAll();
  }

  @override
  Future<void> clearAllTasks() async {
    await isar.writeTxn(() async {
      await isar.normalTasks.clear();
    });
  }

  @override
  Future<void> deleteTask(String id) async {
    final task = await isar.normalTasks
        .filter()
        .idEqualTo(id)
        .findFirst();

    if (task != null) {
      await isar.writeTxn(() async {
        await isar.normalTasks.delete(task.isarId);
      });
    }
  }

  @override
  Future<NormalTask> addTask(NormalTask task) async {
    await isar.writeTxn(() async {
      await isar.normalTasks.put(task);
    });
    return task;
  }

  @override
  Future<NormalTask?> getTask(String id) async {
    return await isar.normalTasks
        .filter()
        .idEqualTo(id)
        .findFirst();
  }

  @override
  Future<NormalTask> updateTask(String id, NormalTask updatedTask) async {
    final task = await getTask(id);
    if (task != null) {
      updatedTask.isarId = task.isarId; // Retain same isar ID
      await isar.writeTxn(() async {
        await isar.normalTasks.put(updatedTask);
      });
      return updatedTask;
    } else {
      throw Exception('Task not found');
    }
  }
}

