import 'package:flutter/material.dart';

enum TaskCategory{
  WORK,
  HOME,
  FAMILY,
}

class Task {
  String id;
  String event;
  TaskCategory category;
  Duration elapsed;

  // Right before app being killed
  DateTime lastTime;

  final Stopwatch sw = Stopwatch();

  // 0 for false, 1 for true
  int isRunningInt;

  Task({
    this.id,
    this.event,
    this.category,
    this.elapsed = Duration.zero,
    this.isRunningInt = 1,
  });

  Task.fromMap(Map<String, dynamic> m) {
    // 00:00:00.000000
    final List<String> eString = m['elapsed'].split(':');
    final int hours = int.parse(eString[0]);
    final int minutes = int.parse(eString[1]);
    final List<String> eSubstring = eString[2].split('.');
    final int seconds = int.parse(eSubstring[0]);
    final int milliseconds = int.parse(eSubstring[1].substring(0, 3));
    final int microseconds = int.parse(eSubstring[1].substring(3, 6));

    final Duration dur = Duration(
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
        microseconds: microseconds,
      );

    this.id = m['id'];
    this.event = m['event'];
    this.category = tcFromString(m['category']);
    this.elapsed = dur;
    this.isRunningInt = m['isRunningInt'];
  }

  bool get isRunning {
    switch (isRunningInt) {
      case 0:
        return false;
      case 1:
        return true;
      default:
        return true;
    }
  }

  Duration get elapsedSinceLastRun {
    if (isRunning)
      return DateTime.now().difference(lastTime);
    else 
      return elapsed;
  }

  void addOneSecond(){
    elapsed += Duration(seconds: 1);
  }

  void toggleIsRunning(bool b){
    if (b)
      isRunningInt = 1;
    else
      isRunningInt = 0;
  }

  void addDuration(Duration diff){
    elapsed += diff;
  }

  Color get catColor {
    switch (this.category) {
      case TaskCategory.HOME:
        return Colors.blue;
      case TaskCategory.WORK:
        return Colors.green;
      case TaskCategory.FAMILY:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  /// toMap
  /// 
  /// Returns a map representation of the Task object
  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'event' : event,
      'category' : tcString, //tcString(),
      'elapsed' : elapsed.toString(),
      'isRunningInt' : isRunningInt, //elapsed.toString(),
    };
  }

  String get tcString{
    switch (category) {
      case TaskCategory.FAMILY:
        return 'Family';
      case TaskCategory.HOME:
        return 'Home';
      case TaskCategory.WORK:
        return 'Work';
      default:
        return 'Work';
    }
  }

  TaskCategory tcFromString(String tc){
    switch (tc) {
      case 'Family':
        return TaskCategory.FAMILY;
      case 'Home':
        return TaskCategory.HOME;
      case 'Work':
        return TaskCategory.WORK;
      default:
        return TaskCategory.FAMILY;
    }
  }

}