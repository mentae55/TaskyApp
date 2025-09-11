part of 'task_bloc.dart';

abstract class TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;

  AddTask(this.task);
}

class LoadTasks extends TaskEvent {}

class ClearAllTasks extends TaskEvent {}
