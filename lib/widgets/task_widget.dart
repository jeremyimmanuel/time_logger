import 'dart:async';

import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/task_list.dart';

class TaskWidget extends StatefulWidget {
  TaskWidget({
    Key key,
    @required this.t,
  }) : super(key: key);

  final Task t;

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> with WidgetsBindingObserver {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  String _timeStamp = '00:00:00';

  bool _isRunning;
  final sw = Stopwatch();
  final dur = const Duration(milliseconds: 20);
  Timer timer;

  @override
  void initState() {
    _isRunning = widget.t.isRunning;
    if (_isRunning) {
      startSW();
    } else {
      stopSW();
    }
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    sw.stop();
    timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state.toString());
    switch (state) {
      case AppLifecycleState.detached:
        _databaseHelper.updateTask(widget.t);
        break;
      case AppLifecycleState.paused: // iOS background ?
        _databaseHelper.updateTask(widget.t);
        break;
      case AppLifecycleState.inactive:
        _databaseHelper.updateTask(widget.t).then((_) => print('updated db'));
        print('${widget.t.event} isRunning ? ${widget.t.isRunning}');
        print(DateTime.now().toString());
        break; 
      default:
    }
  }

  void startSW() {
    timer = Timer(dur, keeprunning);
    sw.start();
    setState(() {
      _isRunning = true;
    });
    widget.t.toggleIsRunning(_isRunning);
    // TODO: find a way to updateTask right before app is killed
    _databaseHelper.updateTask(widget.t);
    
  }

  void keeprunning() {
    if (sw.isRunning) {
      startSW();
    }
    setState(() {
      _timeStamp = sw.elapsed.inHours.toString().padLeft(2, '0') +
          ':' +
          (sw.elapsed.inMinutes % 60).toString().padLeft(2, '0') +
          ':' +
          (sw.elapsed.inSeconds % 60).toString().padLeft(2, '0');
    });
  }

  void stopSW() {
    sw.stop();
    setState(() {
      _isRunning = false;
    });
    widget.t.toggleIsRunning(_isRunning);
    // TODO: find a way to updateTask right before app is killed
    _databaseHelper.updateTask(widget.t);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('$_timeStamp'),
      subtitle: Row(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.tight(
              Size(10, 10),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: widget.t.catColor,
            ),
          ),
          SizedBox(width: 5),
          Text('${widget.t.event}'),
        ],
      ),
      trailing: FloatingActionButton(
        backgroundColor: Colors.grey,
        child: Icon(
          sw.isRunning ? Icons.pause : Icons.play_arrow,
        ),
        onPressed: sw.isRunning ? stopSW : startSW,
      ),
    );
  }
}
