import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/task.dart';
import '../../service/task_path_service.dart';

part 'task_event.dart';

part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskPathService repository;

  TaskBloc(this.repository) : super(TaskInitial()) {
    on<AddTask>(_onAddTask);
    on<LoadTasks>(_onLoadTasks);
    on<ClearAllTasks>(_onClearAllTasks);

    add(LoadTasks());
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      List<Task> updatedTasks = [];

      if (state is TaskLoaded) {
        updatedTasks = List<Task>.from((state as TaskLoaded).tasks)
          ..add(event.task);
      } else {
        updatedTasks = [event.task];
      }

      await repository.saveTasks(updatedTasks);

      emit(TaskLoaded(updatedTasks));

      if (kDebugMode) {
        print('Task added successfully: ${event.task.title}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding task: $e');
      }
      add(LoadTasks());
    }
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    try {
      final tasks = await repository.loadTasks();
      emit(TaskLoaded(tasks));
      if (kDebugMode) {
        print('Loaded ${tasks.length} tasks');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading tasks: $e');
      }
      emit(TaskLoaded([]));
    }
  }

  Future<void> _onClearAllTasks(
    ClearAllTasks event,
    Emitter<TaskState> emit,
  ) async {
    await repository.clearTasks();
    emit(TaskLoaded([]));
  }
}
