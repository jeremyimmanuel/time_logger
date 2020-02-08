import 'package:flutter/material.dart';
import 'package:time_logger/models/task.dart';
import 'package:time_logger/widgets/new_task.dart';
import 'package:sqflite/sqflite.dart';

import '../widgets/task_widget.dart';
import '../models/task_list.dart';

class SWPage extends StatefulWidget {
  SWPage();

  @override
  _SWPageState createState() => _SWPageState();
}

class _SWPageState extends State<SWPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Task> tl = [];

  int count = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // print('got to disposed');
    // for (var t in tl) {
    //   databaseHelper.updateTask(t);
    // }
    super.dispose();
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Task>> taskListFuture = databaseHelper.getTaskList();
      taskListFuture.then((taskList) {
        setState(() {
          this.tl = taskList;
          this.count = taskList.length;
        });
      });
    });
  }

  Future<void> removeTaskInDb(String id) async {
    await databaseHelper.deleteTask(id);
  }

  void _showAddNewTask() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return NewTask();
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    updateListView();
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Time Logger'),
      ),
      body: Container(
        // TODO: adjust height?
        height: mediaQuery.size.height * .8,
        child: ListView.builder(
          itemBuilder: (ctx, i) {
            final t = tl[i];
            return Dismissible(
              key: Key(t.id),
              child: TaskWidget(t: t),
              onDismissed: (direction) {
                removeTaskInDb(t.id);
                setState(() {
                  tl.removeAt(i);
                });
              },
              direction: DismissDirection.startToEnd,
              background: Container(
                child: Center(
                  child: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  border: Border.all(
                    color: Colors.redAccent,
                  ),
                ),
              ),
            );
          },
          itemCount: tl.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showAddNewTask,
      ),
    );
  }
}
