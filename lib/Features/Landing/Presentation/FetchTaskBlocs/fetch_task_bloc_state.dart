part of 'fetch_task_bloc.dart';

abstract class FetchTaskState {}

class TaskInitial extends FetchTaskState {}

class TaskLoading extends FetchTaskState {}

class TaskSuccess<T> extends FetchTaskState {
  final T data;
  TaskSuccess(this.data);
}

class TaskFailure extends FetchTaskState {
  final String message;
  TaskFailure(this.message);
}
