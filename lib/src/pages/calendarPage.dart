import 'package:flutter/material.dart';
import 'package:weho/src/pages/reportHoursPage.dart';
import '../widgets/sidebar.dart';
import '../services/hours.service.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final HoursService _hoursSvc = new HoursService();
  Map<String, dynamic> _stats;

  @override
  void initState() {
    super.initState();
    _hoursSvc.getStatistics().then((res) {
      setState(() {
        _stats = res;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      drawer: Sidebar(),
      body: Center(
        child: Builder(
          builder: (context) {
            if (_stats == null) {
              return CircularProgressIndicator();
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    'Today: ' + _formatMinutes(_stats['today']),
                    style: TextStyle(fontSize: 22)
                ),
                Text(
                    'This week: ' + _formatMinutes(_stats['lastWeek']),
                    style: TextStyle(fontSize: 22)
                ),
                Text(
                    'This month: ' + _formatMinutes(_stats['lastMonth']),
                    style: TextStyle(fontSize: 22)
                ),
              ],
            );
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReportHoursPage())
          );
          var res = await _hoursSvc.getStatistics();
          setState(() {
            _stats = res;
          });
        },
        tooltip: 'Report',
        child: Icon(Icons.add),
      ),
    );
  }

  String _formatMinutes(int minutes) {
    return (minutes / 60).toString() + 'h';
  }
}
