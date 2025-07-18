import 'package:fpdart/fpdart.dart';
import 'package:task_wizard/Features/CreateTask/Presentation/Services/notifications_controller.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/normal_task_entity.dart';
import 'package:task_wizard/Features/Shared/Utils/connectivity.dart';
import '../../Shared/Data/remote_data_sources.dart/task_remote_data_source.dart';

class TaskRepos {
  final TaskRemoteDataSource _offlineTaskRemoteDataSource;
  final TaskRemoteDataSource _taskRemoteDataSource;
  

  TaskRepos({
    required TaskRemoteDataSource taskRemoteDataSource,
    required TaskRemoteDataSource offlineTaskRemoteDataSource,
  })  : _offlineTaskRemoteDataSource = offlineTaskRemoteDataSource,
        _taskRemoteDataSource = taskRemoteDataSource;

  Future<Either<String, NormalTask>> addTask(NormalTask task) async {
    try {
      late final NormalTask normalTask;
      if (await NetworkManager.instance.isConnected()) {
        normalTask = await _taskRemoteDataSource.addTask(task);
      } else {
        task.syncStatus = SyncStatus.add;
        normalTask = await _offlineTaskRemoteDataSource.addTask(task);
        // You can persist sync flag in Hive or SharedPreferences if needed
      }
      NotificationsController.scheduleTaskReminder(task, task.id);
      return Right(normalTask);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, NormalTask>> updateTask(
    String id,
    NormalTask task,
  ) async {
    try {
      late final NormalTask updatedTask;
      if (await NetworkManager.instance.isConnected()) {
        updatedTask = await _taskRemoteDataSource.updateTask(id, task);
      } else {
        task.syncStatus = SyncStatus.update;
        updatedTask = await _offlineTaskRemoteDataSource.updateTask(id, task);
      }
      return Right(updatedTask);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> deleteTask(String id) async {
    try {
      if (await NetworkManager.instance.isConnected()) {
        await _taskRemoteDataSource.deleteTask(id);
      } else {
        final task = await _offlineTaskRemoteDataSource.getTask(id);
        if (task != null) {
          task.syncStatus = SyncStatus.delete;
          await _offlineTaskRemoteDataSource.updateTask(id, task);
        }
      }
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, NormalTask?>> getTask(String id) async {
    try {
      final task = await _offlineTaskRemoteDataSource.getTask(id);
      return Right(task);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<NormalTask>>> getAllTasks() async {
    try {
      final tasks = await _offlineTaskRemoteDataSource.getAllTasks();
      return Right(tasks);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<NormalTask>>> getTasksByCategory(
      String category) async {
    try {
      final tasks =
          await _offlineTaskRemoteDataSource.getTasksByCategory(category);
      return Right(tasks);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<NormalTask>>> getTasksByDate(DateTime date) async {
    try {
      final tasks = await _offlineTaskRemoteDataSource.getTasksByDate(date);
      return Right(tasks);
    } catch (e) {
      return Left(e.toString());
    }
  }
}

