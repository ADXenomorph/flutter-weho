import 'dart:convert';
import 'package:http/http.dart';
import 'package:weho/main.dart';
import 'package:weho/src/entities/project.dart';
import 'package:weho/src/services/auth.service.dart';

class ProjectsService {
  String _token = AuthService.token;
  Client _client = Client();

  Future<List<ProjectEntity>> getProjects() async {
    final res = await _client.get(
      "$baseUrl/api/projects/my",
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "JWT $_token"
      }
    );

    return (json.decode(res.body) as List)
      .map((project) => ProjectEntity.fromJson(project))
      .toList();
  }
}