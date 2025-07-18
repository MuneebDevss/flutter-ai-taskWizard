import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_wizard/Features/CreateTask/Domain/task_repos.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/normal_task_entity.dart';
part "fetch_bloc_events.dart";
part 'fetch_task_bloc_state.dart';

class FetchTaskBloc extends Bloc<FetchTaskEvent, FetchTaskState> {
  final TaskRepos taskRepository;

  FetchTaskBloc({required this.taskRepository}) : super(TaskInitial()) {
    on<GetTasksByCategoryEvent>((event, emit) async {
      emit(TaskLoading());
      final result = await taskRepository.getTasksByCategory(event.category);
      result.fold(
        (error) => emit(TaskFailure(error)),
        (task) => emit(TaskSuccess<List<NormalTask>>(task)),
      );
    });
    on<GetAllTasksEvent>((event, emit) async {
      emit(TaskLoading());
      final result = await taskRepository.getAllTasks();
      result.fold(
        (error) => emit(TaskFailure(error)),
        (task) => emit(TaskSuccess<List<NormalTask>>(task)),
      );
    });
    on<GetTasksByDateEvent>((event, emit) async {
      emit(TaskLoading());
      final result = await taskRepository.getTasksByDate(event.date);
      result.fold(
        (error) => emit(TaskFailure(error)),
        (tasks) => emit(TaskSuccess<List<NormalTask>>(tasks)),
      );
    });
  }
}
