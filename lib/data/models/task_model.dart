import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String status;

  @HiveField(4)
  DateTime createdDate;

  @HiveField(5)
  int priority;

  @HiveField(6)
  String? remoteId; // ✅ Store _id from API if available

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdDate,
    required this.priority,
    this.remoteId,
  });

  /// ✅ Parse from API JSON (GET)
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['_id'] ?? json['id'], // _id from API (e.g. crudcrud)
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdDate: DateTime.parse(json['createdDate']),
      priority: json['priority'],
      remoteId: json['_id'], // ✅ store the original _id
    );
  }

  /// ✅ Convert to JSON for API (POST, PUT)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'createdDate': createdDate.toIso8601String(),
      'priority': priority,
      // ❌ Exclude 'id' or 'remoteId' from body on purpose!
    };
  }
}
