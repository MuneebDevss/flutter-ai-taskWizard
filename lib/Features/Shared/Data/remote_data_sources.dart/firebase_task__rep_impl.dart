// firebase_task_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_wizard/Features/Shared/Data/remote_data_sources.dart/task_remote_data_source.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/normal_task_entity.dart';

class FirebaseTaskRemoteImplementaion implements TaskRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  CollectionReference get _tasksCollection =>
      _firestore.collection('users').doc(_userId).collection('tasks');

  @override
  Future<NormalTask> addTask(NormalTask task) async {
    try {
      final docRef = _tasksCollection.doc();
      task.id = docRef.id;
      _tasksCollection.add(task.toMap());
      return task;
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  @override
  Future<NormalTask?> getTask(String id) async {
    try {
      final doc = await _tasksCollection.doc(id).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return NormalTask.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get task: $e');
    }
  }

  @override
  Future<List<NormalTask>> getAllTasks() async {
    try {
      final querySnapshot = await _tasksCollection.get();
      return querySnapshot.docs
          .map((doc) => NormalTask.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all tasks: $e');
    }
  }

  @override
  Future<NormalTask> updateTask(String id, NormalTask task) async {
    try {
      await _tasksCollection.doc(id).update(task.toMap());
      return task;
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await _tasksCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  @override
  Future<List<NormalTask>> getTasksByDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final querySnapshot =
          await _tasksCollection
              .where('start_date', isGreaterThanOrEqualTo: startOfDay)
              .where('start_date', isLessThanOrEqualTo: endOfDay)
              .get();

      return querySnapshot.docs
          .map((doc) => NormalTask.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get tasks by date: $e');
    }
  }

  @override
  Future<void> clearAllTasks() {
    // TODO: implement clearAllTasks
    throw UnimplementedError();
  }

  @override
  Future<List<NormalTask>> getTasksByCategory(String category) {
    // TODO: implement getTasksByCategory
    throw UnimplementedError();
  }

  @override
  Future<void> saveAllTasks(List<NormalTask> tasks) {
    // TODO: implement saveAllTasks
    throw UnimplementedError();
  }
}
