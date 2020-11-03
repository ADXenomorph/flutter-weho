import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:weho/main.dart';
import 'package:weho/src/entities/project.dart';
import 'package:weho/src/entities/task.dart';
import 'package:weho/src/services/auth.service.dart';

class TasksService {
  String _token = AuthService.token;

  Client _client = Client();

  Future<List<TaskEntity>> getTasksInProgress(int projectId) async {
    final res = await _client.get(
      '$baseUrl/api/tasks/users/my/projects/$projectId'
      '?status=new&status=in%20progress',
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: "JWT $_token"
      }
    );

    return (json.decode(res.body) as List)
      .map((task) => TaskEntity.fromJson(task))
      .toList();
  }
}