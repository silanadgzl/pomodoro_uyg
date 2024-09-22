import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../../providers/time_counter.dart';

class HourPage extends StatefulWidget {
  const HourPage({Key? key}) : super(key: key);

  static int totalMinutes = 0;
  static int initialMinutes = 0;

  static const List<String> daysOfWeek = [
    "Pazartesi",
    "Salı",
    "Çarşamba",
    "Perşembe",
    "Cuma",
    "Cumartesi",
    "Pazar"
  ];

  @override
  _HourPageState createState() => _HourPageState();
}

class _HourPageState extends State<HourPage> {
  TextEditingController dailyHoursController = TextEditingController();
  TextEditingController dailyMinutesController = TextEditingController();
  CountDownController _countDownController = CountDownController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      HourPage.totalMinutes = prefs.getInt('totalMinutes') ?? 0;
      HourPage.initialMinutes = prefs.getInt('initialMinutes') ?? 0;
    });
    if (HourPage.totalMinutes > 0) {
      _countDownController.start();
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Emin misiniz?", style: TextStyle(color: Colors.green)),
          content: Text("Saat ve dakika kaydedilecek."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Hayır", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                _saveTime();
                Navigator.of(context).pop();
              },
              child: Text("Evet", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _showReset() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Emin misiniz?", style: TextStyle(color: Colors.red)),
          content: Text("Bütün Hafta Resetlenecek!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Hayır", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Provider.of<TimeProvider>(context, listen: false)
                    .resetWeeklyData();
                setState(() {
                  HourPage.totalMinutes = 0;
                  HourPage.initialMinutes = 0;
                  _saveTotalMinutes();
                });
                _countDownController.reset();
                Navigator.of(context).pop();
              },
              child: Text("Evet", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _saveTime() {
    int dailyHours = int.tryParse(dailyHoursController.text) ?? 0;
    int dailyMinutes = int.tryParse(dailyMinutesController.text) ?? 0;
    int minutes = (dailyHours * 60) + dailyMinutes;

    setState(() {
      HourPage.totalMinutes = minutes;
      HourPage.initialMinutes = minutes;
      _saveTotalMinutes();
    });
    _countDownController.restart(duration: minutes * 60);
  }

  void _saveTotalMinutes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('totalMinutes', HourPage.totalMinutes);
    prefs.setInt('initialMinutes', HourPage.initialMinutes);
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(color: Colors.blue.shade100),
          ),
          title: const Text('Haftalık Çalışma Saatleri'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _showReset();
              },
            ),
          ],
        ),
        body: FutureBuilder<Map<String, int>>(
          future: Provider.of<TimeProvider>(context, listen: false)
              .getWeeklyStudyData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Veriler yüklenemedi'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Veri yok'));
            } else {
              Map<String, int> data = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: TextField(
                                controller: dailyHoursController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Saat',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextField(
                                controller: dailyMinutesController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Dakika',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _showConfirmationDialog,
                            icon: Icon(Icons.task_alt),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Text(
                        "Günlük hedefim: ${HourPage.initialMinutes} dakika (${HourPage.initialMinutes ~/ 60} saat ${HourPage.initialMinutes % 60} dakika)",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Center(
                      child: CircularCountDownTimer(
                        duration: HourPage.totalMinutes >= 0
                            ? HourPage.totalMinutes * 60
                            : HourPage.totalMinutes = 0,
                        initialDuration: 0,
                        controller: _countDownController,
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 2,
                        ringColor: Colors.grey[300]!,
                        ringGradient: null,
                        fillColor: Colors.blueAccent,
                        fillGradient: null,
                        backgroundColor: Colors.blue[500],
                        backgroundGradient: null,
                        strokeWidth: 20.0,
                        strokeCap: StrokeCap.round,
                        textStyle: TextStyle(
                            fontSize: 33.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textFormat: CountdownTextFormat.HH_MM_SS,
                        isReverse: true,
                        isReverseAnimation: true,
                        isTimerTextShown: true,
                        autoStart: false,
                        onStart: () {
                          debugPrint('Geri sayım başladı');
                        },
                        onComplete: () {
                          debugPrint('Geri sayım tamamlandı');
                          setState(() {
                            HourPage.totalMinutes = 0; // Süreyi sıfırla
                          });
                        },
                        onChange: (String timeStamp) {
                          debugPrint('Geri sayım değişti: $timeStamp');
                        },
                      ),
                    ),
                    Center(
                        child: Text(
                      "Hedefe kalan süre: ${HourPage.totalMinutes} dakika (${HourPage.totalMinutes ~/ 60} saat ${HourPage.totalMinutes % 60} dakika)",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              HourPage.daysOfWeek.asMap().entries.map((entry) {
                            int index = entry.key;
                            String day = entry.value;
                            int weeklyMinutes =
                                data[(index + 1).toString()] ?? 0;
                            double height = 30 + weeklyMinutes.toDouble() * 0.2;

                            Color startColor = Colors.lightBlueAccent;
                            Color endColor = Colors.blue;
                            double t = (height - 30) / (30 + 240);
                            Color barColor =
                                Color.lerp(startColor, endColor, t)!;

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 270,
                                  child: FractionallySizedBox(
                                    alignment: Alignment.bottomCenter,
                                    heightFactor: height / 270,
                                    child: Container(
                                      width: 50,
                                      color: barColor,
                                      margin: const EdgeInsets.all(8),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  day,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${((weeklyMinutes ~/ 60) / 2).toInt()}s ${((weeklyMinutes % 60) / 2).toInt()} d',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                                SizedBox(height: 50),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      );
  }
}
