import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_wizard/Features/CreateTask/Domain/task_repos.dart';
import 'package:task_wizard/Features/CreateTask/Presentation/CreateTaskBlocs/bloc_events.dart';
import 'package:task_wizard/Features/CreateTask/Presentation/CreateTaskBlocs/create_task_bloc_state.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/normal_task_entity.dart';

class AddTaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepos taskRepository;

  AddTaskBloc({required this.taskRepository}) : super(TaskInitial()) {
    on<AddTaskEvent>((event, emit) async {
      emit(TaskLoading());
      final result = await taskRepository.addTask(event.task);

      result.fold((error) => emit(TaskFailure(error)), (task) {
        emit(TaskSuccess<NormalTask>(task));
      });
    });

    on<GetTaskEvent>((event, emit) async {
      emit(TaskLoading());
      final result = await taskRepository.getTask(event.id);
      result.fold(
        (error) => emit(TaskFailure(error)),
        (task) => emit(TaskSuccess<NormalTask?>(task)),
      );
    });

    on<GetAllTasksEvent>((event, emit) async {
      emit(TaskLoading());
      final result = await taskRepository.getAllTasks();
      result.fold(
        (error) => emit(TaskFailure(error)),
        (tasks) => emit(TaskSuccess<List<NormalTask>>(tasks)),
      );
    });

    on<UpdateTaskEvent>((event, emit) async {
      emit(TaskLoading());
      final result = await taskRepository.updateTask(event.id, event.task);
      result.fold(
        (error) => emit(TaskFailure(error)),
        (task) => emit(TaskSuccess<NormalTask>(task)),
      );
    });

    on<DeleteTaskEvent>((event, emit) async {
      emit(TaskLoading());
      final result = await taskRepository.deleteTask(event.id);
      result.fold(
        (error) => emit(TaskFailure(error)),
        (_) => emit(TaskSuccess<String>('Task deleted')),
      );
    });
  }
}
