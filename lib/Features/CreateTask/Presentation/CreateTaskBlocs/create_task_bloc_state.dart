abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskSuccess<T> extends TaskState {
  final T data;
  TaskSuccess(this.data);
}

class TaskFailure extends TaskState {
  final String message;
  TaskFailure(this.message);
}
