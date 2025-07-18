part of 'fetch_task_bloc.dart';

abstract class FetchTaskEvent {}

class GetTasksByCategoryEvent extends FetchTaskEvent {
  final String category;
  GetTasksByCategoryEvent(this.category);
}

class GetAllTasksEvent extends FetchTaskEvent {
  GetAllTasksEvent();
}

class GetTasksByDateEvent extends FetchTaskEvent {
  final DateTime date;
  GetTasksByDateEvent(this.date);
}
