import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class Sound extends ChangeNotifier {
  final oynatici = AudioPlayer();
  static String x = "";
  bool alarmCalisiyor = true;

  List<String> sesler = [
    "Sessiz",
    "Titreşim",
    "alarm1.mp3",
    "alarm2.mp3",
    "alarm3.mp3",
    "alarm4.mp3",
    "alarm5.mp3",
    "alarm6.mp3",
    "alarm7.mp3",
    "alarm8.mp3",
    "alarm9.mp3",
    "alarm10.mp3",
    "alarm11.mp3",
    "alarm12.mp3",
    "alarm13.mp3",
  ];

  static Future<void> initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedIndex = prefs.getInt('selectedSoundIndex');
    if (savedIndex != null) {
      x = Sound().sesler[savedIndex];
    }
  }

  void sesOynat() {
    if (alarmCalisiyor && x != "Titreşim") {
      oynatici.play(AssetSource(x));
      notifyListeners();
    }
  }

  void sesDurdur() {
    oynatici.stop();
    print('Ses durduruldu.');
  }

  Future<void> vibrate() async {
    if (alarmCalisiyor && x == "Titreşim") {
      Vibration.vibrate(
        pattern: [500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500],
      );
    }
  }

  void setSes(String yeniSes) {
    x = yeniSes;
  }
}
