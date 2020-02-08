import 'dart:core';

import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/task_list.dart';

class NewTask extends StatefulWidget {
  NewTask({Key key}) : super(key: key);

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController _eventController = TextEditingController();
  String dropDownCat = 'Home';

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  Future<void> _addTask() async {
    Task newT = Task(
      id: DateTime.now().toString(),
      event: _eventController.text,
      category: _tcFactory(),
    );
    await databaseHelper.insertTask(newT);
    print('added new task');
    Navigator.of(context).pop();
  }

  TaskCategory _tcFactory() {
    switch (dropDownCat) {
      case 'Home':
        return TaskCategory.HOME;
        break;
      case 'Family':
        return TaskCategory.FAMILY;
      case 'Work':
        return TaskCategory.WORK;
      default:
        return TaskCategory.FAMILY;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Add new task',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: _eventController,
            cursorColor: Colors.black,
          ),
          SizedBox(height: 1),
          DropdownButton(
              value: dropDownCat,
              icon: Icon(Icons.arrow_drop_down),
              items: ['Home', 'Family', 'Work']
                  .map((v) => DropdownMenuItem<String>(
                        value: v,
                        child: Text(v),
                      ))
                  .toList(),
              onChanged: (v) {
                setState(() {
                  dropDownCat = v;
                });
              }),
          FloatingActionButton(
            onPressed: _addTask,
            shape: BeveledRectangleBorder(),
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
