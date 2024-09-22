import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui/widgets/alert_dialog.dart';
import '../ui/pages/count_down_page.dart';
import '../ui/pages/hour_page.dart';

class TimeProvider with ChangeNotifier {
  late int _remainingSeconds;
  late Timer _timer;
  bool _isRunning = false;
  bool _isPaused = false;

  TimeProvider() {
    _remainingSeconds = 2 * 60;
    _loadSelectedValue();
    _checkNewDay();
  }

  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;

  Future<void> _loadSelectedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedValue = prefs.getInt('selectedValue');
    if (savedValue != null) {
      setTimerDuration(savedValue ~/ 60);
    }
  }

  void _saveSelectedValue(int seconds) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedValue', seconds);
  }

  void setTimerDuration(int minutes) {
    _remainingSeconds = minutes * 60;
    _saveSelectedValue(_remainingSeconds);
    notifyListeners();
  }

  void startTimer(BuildContext context) {
    if (!_isRunning) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          if (!_isPaused) {
            _remainingSeconds--;
            notifyListeners();
          }
        } else {
          alertdialog(context);
        }
      });
      _isRunning = true;
      _isPaused = false;
    }
  }

  void alertdialog(BuildContext context) {
    if (_remainingSeconds <= 0) {
      showCongratsDialog(context);
      int elapsedMinutes = int.parse(CountDown.selectedValue) - (_remainingSeconds ~/ 60);
      HourPage.totalMinutes -= elapsedMinutes;
      _updateDailyStudyTime(int.parse(CountDown.selectedValue));
      _saveTotalMinutes();
      resetTimer();
    }
  }

  void _updateDailyStudyTime(int minutes) async {
    await _checkNewDay();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dayOfWeek = DateTime.now().weekday.toString();
    int existingMinutes = prefs.getInt(dayOfWeek) ?? 0;
    prefs.setInt(dayOfWeek, existingMinutes + minutes);
    notifyListeners();
  }

  void stopTimer() {
    if (_isRunning) {
      _timer.cancel();
      _isRunning = false;
      _isPaused = false;
      notifyListeners();
    }
  }

  void resetTimer() {
    if (_remainingSeconds == 0) {
      _updateDailyStudyTime(int.parse(CountDown.selectedValue));
    }
    _remainingSeconds = int.parse(CountDown.selectedValue) * 60;
    _saveSelectedValue(_remainingSeconds);
    if (_isRunning) {
      stopTimer();
    }
    notifyListeners();
  }

  void togglePauseResume() {
    if (_isRunning) {
      _isPaused = !_isPaused;
      notifyListeners();
    }
  }

  Future<Map<String, int>> getWeeklyStudyData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, int> weeklyData = {};
    for (int i = 1; i <= 7; i++) {
      String dayOfWeek = i.toString();
      weeklyData[dayOfWeek] = prefs.getInt(dayOfWeek) ?? 0;
    }
    return weeklyData;
  }

  void resetWeeklyData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 1; i <= 7; i++) {
      String dayOfWeek = i.toString();
      await prefs.remove(dayOfWeek);
    }
    notifyListeners();
  }

  Future<void> _checkNewDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastDay = prefs.getString('lastDay');
    String currentDay = DateTime.now().weekday.toString();

    if (lastDay != null && lastDay != currentDay) {
      if (lastDay == "7" && currentDay == "1") {
        for (int i = 1; i <= 7; i++) {
          String dayOfWeek = i.toString();
          await prefs.remove(dayOfWeek);
        }
      }
      await prefs.remove('totalMinutes');  // Geçmiş günü temizle
      await prefs.remove('initialMinutes'); // İlk girilen değeri temizle
      HourPage.totalMinutes = 0;
      HourPage.initialMinutes = 0;
      prefs.setInt('totalMinutes', 0);  // Kaydet
      prefs.setInt('initialMinutes', 0); // Kaydet
    }

    prefs.setString('lastDay', currentDay);
  }

  void _saveTotalMinutes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('totalMinutes', HourPage.totalMinutes);
    prefs.setInt('initialMinutes', HourPage.initialMinutes);
  }

  @override
  void dispose() {
    if (_isRunning) {
      _timer.cancel();
    }
    super.dispose();
  }
}