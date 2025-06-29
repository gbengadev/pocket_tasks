class Task {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final DateTime? dueDate;

  Task({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.dueDate,
  });

  // Convert a Task to a Map for SQLite
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'status': status,
        'due_date': dueDate?.toIso8601String(),
      };

  // Convert a Map from SQLite to a Task
  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'],
        title: map['title'],
        content: map['content'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']),
        status: map['status'],
        dueDate:
            map['due_date'] != null ? DateTime.parse(map['due_date']) : null,
      );

  // Create a copy with optional changes
  Task copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
