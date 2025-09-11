part of 'task_bloc.dart';

sealed class TaskState {}

final class TaskInitial extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;

  TaskLoaded(this.tasks);
}
