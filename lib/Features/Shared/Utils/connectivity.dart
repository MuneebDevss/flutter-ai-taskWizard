import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/normal_task_entity.dart';
import 'package:task_wizard/Features/Shared/Data/remote_data_sources.dart/task_remote_data_source.dart';

/// Manages the network connectivity status and provides methods to check and handle connectivity changes.
class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final Rx<List<ConnectivityResult>> _connectionStatus =
      Rx<List<ConnectivityResult>>([]);

  /// Initialize the network manager and set up a stream to continually check the connection status.
  @override
  Future<void> onInit() async {
    super.onInit();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  /// Update the connection status based on changes in connectivity and show a relevant popup for no internet connection.
  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus.value = result;
    if (!result.contains(ConnectivityResult.wifi)) {
      ScaffoldMessenger.of(
        Get.context!,
      ).showSnackBar(const SnackBar(content: Text('No internet connection')));
    }
  }

  void startConnectivityListener(Isar isar, TaskRemoteDataSource remoteDS) {
    final connectivity = Connectivity();

    connectivity.onConnectivityChanged.listen((result) async {
      if (await isConnected()) {
        final unsyncedTasks =
            await isar.normalTasks
                .filter()
                .not()
                .syncStatusEqualTo(SyncStatus.synced)
                .findAll();
        for (var task in unsyncedTasks) {
          
          try {
            if (task.syncStatus == SyncStatus.add) {
              final newTask = await remoteDS.addTask(task);
              task.id = newTask.id;
            } else if (task.syncStatus == SyncStatus.update) {
              await remoteDS.updateTask(task.id, task);
            } else if (task.syncStatus == SyncStatus.delete) {
              await remoteDS.deleteTask(task.id);
              await isar.writeTxn(() async {
                await isar.normalTasks.delete(task.isarId);
              });
              continue; // Skip marking as synced
            }

            task.syncStatus = SyncStatus.synced;
            await isar.writeTxn(() async {
              await isar.normalTasks.put(task);
            });
          } catch (e) {
            // handle sync error
            print('Sync error: $e');
          }
        }
      }
    });
  }

  /// Check the internet connection status.
  /// Returns true if connected, false otherwise.
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile);
    } catch (e) {
      return false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription
        .cancel(); // Cancel the subscription to avoid memory leaks
  }
}
