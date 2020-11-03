import 'package:flutter/material.dart';
import 'package:weho/src/entities/project.dart';
import 'package:weho/src/entities/task.dart';
import 'package:weho/src/services/hours.service.dart';
import 'package:weho/src/services/projects.service.dart';
import 'package:weho/src/services/tasks.service.dart';

class ReportHoursPage extends StatefulWidget {
  @override
  _ReportHoursPageState createState() => _ReportHoursPageState();
}

class _ReportHoursPageState extends State<ReportHoursPage> {
  List<ProjectEntity> _projects;
  List<TaskEntity> _tasks;

  final _hoursCtrl = TextEditingController();
  int _selectedProject;
  int _selectedTask;
  final _commentCtrl = TextEditingController();


  @override
  void initState() {
    super.initState();
    ProjectsService().getProjects().then((res) {
      setState(() {
        _projects = res;
      });
    });
  }

  _submitHours(BuildContext context) {
    new HoursService()
      .submitHours(
        int.parse(this._hoursCtrl.text, radix: 10) * 60,
        this._selectedTask,
        this._commentCtrl.text,
        new DateTime.now().millisecondsSinceEpoch,
        this._selectedProject
      )
      .then((res) {
        Navigator.of(context).pop();
      });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Report hours'),
      ),
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .1),
                    _entryField(_hoursCtrl, 'Hours'),
                    SizedBox(height: 20),
                    _projectAndTask(),
                    SizedBox(height: 20),
                    _entryField(_commentCtrl, 'Comment'),
                    SizedBox(height: 20),
                    _submitButton(context)
                  ],
                )
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _projectAndTask() {
    if (_selectedProject != null && _tasks == null) {
      TasksService().getTasksInProgress(_selectedProject).then((tasks) {
        setState(() {
          _tasks = tasks;
        });
      });
    }

    return Column(
      children: <Widget>[
        _project(),
        SizedBox(height: 20),
        _task(_selectedProject != null ? _tasks : [])
      ],
    );
  }

  Widget _project() {
    if (_projects == null) {
      return CircularProgressIndicator();
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Project',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Listener(
            onPointerDown: (_) => FocusScope.of(context).unfocus(),
            child: DropdownButton<int>(
              isExpanded: true,
              hint: new Text("Project"),
              value: _selectedProject,
              onChanged: (int newValue) {
                setState(() {
                  _selectedProject = newValue;
                  _tasks = null;
                });
              },
              items: _projects.map((ProjectEntity project) {
                return DropdownMenuItem<int>(
                  value: project.projectId,
                  child: Text(project.name),
                );
              }).toList(),
            )
          ),
        ]
      )
    );
  }

  Widget _task(List<TaskEntity> tasks) {
    if (tasks == null) {
      return CircularProgressIndicator();
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Task',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Listener(
            onPointerDown: (_) => FocusScope.of(context).unfocus(),
            child: DropdownButton<int>(
              isExpanded: true,
              hint: new Text("Task"),
              value: _selectedTask,
              onChanged: (int newValue) {
                setState(() {
                  _selectedTask = newValue;
                });
              },
              items: tasks.map((TaskEntity task) {
                return DropdownMenuItem<int>(
                  value: task.taskId,
                  child: Text(task.title),
                );
              }).toList(),
            )
          ),
        ]
      )
    );
  }

  Widget _entryField(TextEditingController ctrl, String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: ctrl,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: title
            ),
          )
        ],
      ),
    );
  }


  Widget _submitButton(BuildContext context) {
    return InkWell(
      onTap: () {
        _submitHours(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2
            )
          ],
          color: Color(0xff2872ba),
        ),
        child: Text(
          'Submit',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      )
    );
  }
}
