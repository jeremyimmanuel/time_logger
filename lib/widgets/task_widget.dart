import 'dart:async';
import 'dart:math';

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
  String _timeStamp;

  // Dur to display
  Duration _totalDur;

  // Local duration
  Duration _currDur = Duration.zero;

  bool _isRunning;
  // final sw = Stopwatch();
  final int _min = 989;
  final int _diff = 6;
  Random r = Random();
  // final dur = const Duration(milliseconds: 990, microseconds: 400);
  Timer timer;

  @override
  void initState() {
    _isRunning = widget.t.isRunning;
    if (widget.t.lastTime != null) {
      DateTime now = DateTime.now();
      final Duration deltaDur = now.difference(widget.t.lastTime);
      print(now.toString());
      print(widget.t.lastTime.toString());
      if (_isRunning) 
        widget.t.addDuration(deltaDur);
    }
    _totalDur = widget.t.elapsed;
    _timeStamp = _totalDur.toString().split('.')[0].padLeft(8, '0');

    print('new version');
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
    // sw.stop();
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
      case AppLifecycleState.paused:
        widget.t.addDuration(_currDur);
        widget.t.setLastTime();
        _databaseHelper.updateTask(widget.t);
        break;
      case AppLifecycleState.inactive:
        widget.t.addDuration(_currDur);
        widget.t.setLastTime();
        print(widget.t.lastTime.toString());
        _databaseHelper.updateTask(widget.t).then((_) => print('updated db'));
        // print('${widget.t.event} isRunning ? ${widget.t.isRunning}');
        // print(DateTime.now().toString());
        break;
      default:
    }
  }

  void startSW() {
    int rInt = _min + r.nextInt(_diff);
    int rMicro = r.nextInt(999);
    Duration dur = Duration(
      milliseconds: rInt,
      microseconds: rMicro,
    );
    timer = Timer(dur, keeprunning);
    if (!_isRunning) {
      // sw.start();
      setState(() {
        _isRunning = true;
      });
      widget.t.toggleIsRunning(_isRunning);
      // TODO: find a way to updateTask right before app is killed
      _databaseHelper.updateTask(widget.t);
    }
  }

  void keeprunning() {
    if (_isRunning) {
      startSW();
    }
    setState(() {
      // print(DateTime.now());
      _totalDur += Duration(seconds: 1);
      _currDur += Duration(seconds: 1);
      _timeStamp = _totalDur.inHours.toString().padLeft(2, '0') +
          ':' +
          (_totalDur.inMinutes % 60).toString().padLeft(2, '0') +
          ':' +
          (_totalDur.inSeconds % 60).toString().padLeft(2, '0');
    });
  }

  void stopSW() {
    // sw.stop();
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
          _isRunning ? Icons.pause : Icons.play_arrow,
        ),
        onPressed: _isRunning ? stopSW : startSW,
      ),
    );
  }
}
