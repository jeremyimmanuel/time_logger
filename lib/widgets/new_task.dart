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
  DatabaseHelper _databaseHelper = DatabaseHelper();
  TextEditingController _eventController = TextEditingController();
  String _dropDownCat = 'Home';
  bool _startImmediately = true;

  FocusNode _eventFocusNode = FocusNode();
  FocusNode _categoryFocusNode = FocusNode();

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
      isRunningInt: _startImmediately ? 1 : 0,
    );
    await _databaseHelper.insertTask(newT);
    Navigator.of(context).pop();
  }

  TaskCategory _tcFactory() {
    switch (_dropDownCat) {
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
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Title
            Text(
              'Add new task',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Event Text Field
            TextField(
              controller: _eventController,
              autofocus: true,
              focusNode: _eventFocusNode,
              cursorColor: Colors.black,
              textInputAction: TextInputAction.next,
              onSubmitted: (s) {
                _eventFocusNode.unfocus();
                FocusScope.of(context).requestFocus(_categoryFocusNode);
              } ,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Task',
              ),
            ),
            SizedBox(height: 1),
            DropdownButton(
                focusNode: _categoryFocusNode,
                value: _dropDownCat,
                icon: Icon(Icons.arrow_drop_down),
                items: ['Home', 'Family', 'Work']
                    .map(
                      (v) => DropdownMenuItem<String>(
                        value: v,
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Task.getCatColor(v),
                              ),
                            ),
                            SizedBox(width: 3),
                            Text(v),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _dropDownCat = v;
                  });
                }),
            SizedBox(height: 1),
            Row(
              children: <Widget>[
                Text('Start immediately'),
                Checkbox(
                  activeColor: Theme.of(context).primaryColor,
                  value: _startImmediately,
                  onChanged: (value) {
                    setState(() {
                      _startImmediately = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 1),
            FloatingActionButton.extended(
              label: Text(
                'Add',
                style: Theme.of(context).textTheme.subtitle,
              ),
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.black,
                  width: 3,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              onPressed: _addTask,
            ),
          ],
        ),
      ),
    );
  }
}
