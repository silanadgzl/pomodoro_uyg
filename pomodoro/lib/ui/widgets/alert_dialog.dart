import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:pomodoro/sound.dart';
import 'package:pomodoro/ui/pages/count_down_page.dart';
import 'package:vibration/vibration.dart';

class FinishAlertDialog extends StatefulWidget {
  @override
  State<FinishAlertDialog> createState() => _FinishAlertDialogState();
}

class _FinishAlertDialogState extends State<FinishAlertDialog> {
  Sound sound = Sound(); // Sound sınıfından bir örnek oluştur

  @override
  void initState() {
    super.initState();
    if (Sound.x == "Titreşim") {
      sound.vibrate(); // Başlangıçta titreşim çal
    } else {
      sound.sesOynat(); // Başlangıçta ses çal
    }
  }

  void stopSound() {
    sound.alarmCalisiyor = false; // Alarmı durdur
    sound.sesDurdur(); // Sesi durdur
    Vibration.cancel(); // Titreşimi durdur
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        stopSound();
        return true; // Dialogun kapanmasına izin ver
      },
      child: AlertDialog(
        title: const Text('Tebrikler'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Lottie.asset(
                  'assets/animation_star.json',
                  width: 80,
                  height: 80,
                ),
              ),
              Center(
                child: Lottie.asset(
                  'assets/animation_astronot.json',
                  width: 80,
                  height: 80,
                ),
              ),
              const SizedBox(height: 16),
              const Center(child: Text('Tebrikler, ders bitti!')),
            ],
          ),
        ),
        actions: [
          IconsButton(
            onPressed: () {
              CountDown.isRunning=false;
              Navigator.of(context).pop();
              stopSound();
            },
            text: 'Kapat',
            iconData: Icons.done,
            color: Colors.blue,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    stopSound();
    super.dispose();
  }
}

void showCongratsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FinishAlertDialog();
    },
  );
}
