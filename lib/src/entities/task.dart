class TaskEntity {
  final int taskId;
  final String title;

  TaskEntity({
    this.taskId,
    this.title
  });

  TaskEntity.fromJson(Map<String, dynamic> json)
    : taskId = json['taskId'],
      title = json['title'];

}