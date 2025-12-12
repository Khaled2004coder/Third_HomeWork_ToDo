// lib/models/task_model.dart
class Task {
  int? id;
  String? title;
  String? description;
  String? priority;
  String? dueDate;
  int? isCompleted;
  String? category;
  String? createdAt;
  int? typeId; // الحقل الجديد

  Task({
    this.id,
    this.title,
    this.description,
    this.priority,
    this.dueDate,
    this.isCompleted,
    this.category,
    this.createdAt,
    this.typeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'dueDate': dueDate,
      'isCompleted': isCompleted,
      'category': category,
      'createdAt': createdAt,
      'typeId': typeId,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as int?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        priority: json['priority'] as String?,
        dueDate: json['dueDate'] as String?,
        isCompleted: json['isCompleted'] as int?,
        category: json['category'] as String?,
        createdAt: json['createdAt'] as String?,
        typeId: json['typeId'] as int?,
      );
}
