import 'package:hive_ce/hive.dart';

part 'task_for_hive.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final bool isHighPriority;

  @HiveField(4)
  final bool isDone;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isHighPriority = false,
    this.isDone = false,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isDone,
    bool? isHighPriority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      isHighPriority: isHighPriority ?? this.isHighPriority,
    );
  }
  factory Task.fromMap(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    isHighPriority: json['isHighPriority'] == 1,
    isDone: json['isDone'] == 1,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isHighPriority': isHighPriority ? 1 : 0,
      'isDone': isDone ? 1 : 0,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String,
      isDone: (json['isDone'] as int? ?? 0) == 1,
      isHighPriority: (json['isHighPriority'] as int? ?? 0) == 1,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  List<Object?> get props => [id, title, description, isDone, isHighPriority];

  @override
  String toString() {
    return 'Task{id: $id, title: $title, description: $description, isHighPriority: $isHighPriority, isDone: $isDone}';
  }
}
