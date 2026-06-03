import 'dart:async';

import 'package:book_life/core/models/book_model.dart';
import 'package:book_life/features/reading_timer/models/lapModel.dart';
import 'package:flutter/foundation.dart';

class LivroTimerViewModel extends ChangeNotifier{
  Book livro;

  int _seconds =0, _minutes =0, _hours =0;
  String digitSeconds = '00', digitMinutes = '00', digitHours = '00';
  bool isRunning = false;
  Timer? _timer;
  DateTime? _startTime;
  List<LapModel> laps = [];

  LivroTimerViewModel(this.livro){
    
  }


  void startTimer(){
    isRunning = true;
    _startTime = DateTime.now();

    int tempoAcumulado = (_hours * 3600) + (_minutes * 60) + _seconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer){
      if(_startTime != null){
        int segundosPassados = DateTime.now().difference(_startTime!).inSeconds;
        int total = tempoAcumulado + segundosPassados;

        
        _seconds = total % 60;
        _minutes = (total % 3600) ~/ 60 ;
        _hours = total ~/ 3600;

        digitSeconds = (_seconds >= 10) ? '$_seconds' : '0$_seconds';
        digitMinutes = (_minutes >= 10) ? '$_minutes' : '0$_minutes';
        digitHours = (_hours >= 10) ? '$_hours' : '0$_hours';

        notifyListeners();
      }
    });
    notifyListeners();
  }

  void stopTimer() {
    _timer!.cancel();
    isRunning = false;
    notifyListeners();
  }

   void resetTimer() {
    _timer!.cancel();
    
      _seconds = 0;
      _minutes = 0;
      _hours = 0;

      digitHours = '00';
      digitMinutes = '00';
      digitSeconds = '00';

      isRunning = false;

      notifyListeners();

  }

  void addLaps() {
    String lap = "$digitHours:$digitMinutes:$digitSeconds";
    DateTime agora = DateTime.now();
    String dataAtual =
        "${agora.day.toString().padLeft(2, '0')}/${agora.month.toString().padLeft(2, '0')}/${agora.year}";
    String horaAtual =
        " às ${agora.hour.toString().padLeft(2, '0')}:${agora.minute.toString().padLeft(2, '0')}";
    laps.add(LapModel(tempo: lap,date: dataAtual, hours: horaAtual ));
    notifyListeners();
  }

  bool get hasProgress => _seconds > 0 || _minutes > 0 || _hours > 0;

  void toggleFavorite() {
    
  }
  
  @override
  void dispose(){
    _timer?.cancel();
    super.dispose();
  }
}

