import 'dart:core';

class SW {
  final Stopwatch _sw = Stopwatch();

  final List<Duration> _savedTimeList = [];

  Duration get elapsed {
    return _sw.elapsed;
  }

  bool get isRunning {
    return _sw.isRunning;
  }

  void startStop(){
    if (_sw.isRunning) {
      _sw.stop();
    } else {
      _sw.start();
    }
  }



  void addTime(){
    _savedTimeList.add(_sw.elapsed);
  }


}