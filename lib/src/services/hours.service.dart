import 'dart:convert';
import 'package:http/http.dart';
import 'package:weho/main.dart';
import 'package:weho/src/services/auth.service.dart';

class HoursService {
  String _token = AuthService.token;
  Client client = Client();

  Future<Map<String, dynamic>> getStatistics() async {
    final res = await client.get(
      "$baseUrl/api/hours/statistic",
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "JWT $_token"
      }
    );

    print(res.statusCode);
    print(res.body);
    // {"today":0,"lastWeek":2520,"lastMonth":11880,"lastYear":45840}

    return json.decode(res.body);
  }

  Future<bool> submitHours(
    int minutes,
    int taskId,
    String comment,
    int submitDate,
    int projectId
  ) async {
    await client.post(
      "$baseUrl/api/hours",
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "JWT $_token"
        },
        body: jsonEncode({
          'minutes': minutes,
          'taskId': taskId,
          'comment': comment,
          'submitDate': submitDate,
          'projectId': projectId,
        })
    );

    return true;
  }
}