import 'package:flutter/material.dart';
import 'package:pomodoro/sound.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class NotificationSound extends StatefulWidget {
  const NotificationSound({Key? key}) : super(key: key);

  @override
  State<NotificationSound> createState() => _NotificationSoundState();
}

class _NotificationSoundState extends State<NotificationSound> {
  Sound soundInstance = Sound(); // Sound sınıfının bir örneği
  late SharedPreferences prefs;

  String currentOptions = Sound().sesler[0];

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    Sound().sesDurdur();
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    int? savedIndex = prefs.getInt('selectedSoundIndex');
    if (savedIndex != null) {
      setState(() {
        currentOptions = Sound().sesler[savedIndex];
        Sound.x = currentOptions; // Sound.x'i seçili seçenekle güncelle
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    soundInstance.sesDurdur();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Bildirim Sesi")),
      body: ListView.builder(
        itemCount: soundInstance.sesler.length,
        itemBuilder: (context, index) => Card(
          color: Colors.blueGrey,
          child: Column(
            children: [
              ListTile(
                title: Text("${soundInstance.sesler[index]}"),
                leading: Radio(
                  value: soundInstance.sesler[index],
                  groupValue: currentOptions,
                  onChanged: (value) {
                    setState(() {
                      currentOptions = value.toString();
                      Sound.x = currentOptions; // Sound.x'i güncelle
                      if (Sound.x == "Titreşim") {
                        soundInstance.vibrate();
                      } else {
                        soundInstance.setSes(Sound.x); // Ses ayarını güncelle
                        soundInstance.sesOynat();
                        Vibration.cancel();
                      }
                      prefs.setInt('selectedSoundIndex', index);
                    });

                    soundInstance.alarmCalisiyor = true;
                    soundInstance.sesDurdur();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
