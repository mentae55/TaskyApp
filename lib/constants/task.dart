class Task {
  final int? id;
  final String title;
  final String description;
  final bool isHighPriority;
  final bool isDone;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isHighPriority = false,
    this.isDone = false,
  });

  Task copyWith({int? id, String? title, String? description, bool? isDone}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      isHighPriority: isHighPriority,
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
      'title': title,
      'description': description,
      'isHighPriority': isHighPriority ? 1 : 0,
      'isDone': isDone ? 1 : 0,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      isDone: (json['isDone'] as int? ?? 0) == 1,
      isHighPriority: (json['isHighPriority'] as int? ?? 0) == 1,
    );
  }

  List<Object?> get props => [id, title, description, isDone];
}
