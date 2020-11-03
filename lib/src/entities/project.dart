class ProjectEntity {
  final int projectId;
  final String name;

  ProjectEntity({
    this.projectId,
    this.name
  });

  ProjectEntity.fromJson(Map<String, dynamic> json)
    : projectId = json['projectId'],
      name = json['name'];

}