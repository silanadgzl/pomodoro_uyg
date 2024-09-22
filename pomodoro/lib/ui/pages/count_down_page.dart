import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/time_counter.dart';
import 'hour_page.dart';

class CountDown extends StatefulWidget {
  const CountDown({super.key});

  static String selectedValue = "2";
  static bool isRunning = false;

  @override
  State<CountDown> createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  @override
  void initState() {
    super.initState();
    _loadSelectedValue();
  }

  Future<void> _loadSelectedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedValue = prefs.getInt('selectedValue');
    if (savedValue != null) {
      setState(() {
        CountDown.selectedValue = (savedValue ~/ 60).toString();
        Provider.of<TimeProvider>(context, listen: false)
            .setTimerDuration(savedValue ~/ 60);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    
    List<String> sayac = [];
    for (int i = 1; i <= 59; i++) {
      sayac.add(i.toString());
    }




    return ChangeNotifierProvider(
      create: (context) => TimeProvider(),
      child: Center(
        child: Column(
          children: [
            Consumer<TimeProvider>(builder: (context, timeProvider, child) {
              return Expanded(
                child: Column(
                  verticalDirection: VerticalDirection.up,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      value: sayac.contains(CountDown.selectedValue)
                          ? CountDown.selectedValue
                          : null,
                      menuMaxHeight: 300,
                      borderRadius: BorderRadius.circular(20),
                      dropdownColor: Colors.grey.shade300,
                      items: sayac.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(
                            child: Text(value,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontFamily: "Jersey25Charted")),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          CountDown.selectedValue = newValue!;
                          int minutes = int.parse(CountDown.selectedValue);
                          timeProvider.setTimerDuration(minutes);
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black87.withOpacity(0.3),
                                spreadRadius: 15,
                                blurRadius: 15,
                                offset: Offset(1, 0),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${timeProvider.remainingSeconds ~/ 60}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 90,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black87.withOpacity(0.3),
                                spreadRadius: 15,
                                blurRadius: 15,
                                offset: Offset(1, 0),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${(timeProvider.remainingSeconds % 60).toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 90,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            Consumer<TimeProvider>(builder: (context, timeProvider, child) {
              return Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Transform.scale(
                              scale: 1.8,
                              child: Switch(
                                inactiveTrackColor: Colors.green.shade100,
                                activeTrackColor: Colors.grey.shade400,
                                value: CountDown.isRunning,
                                activeColor: Colors.blueGrey,
                                inactiveThumbColor: Colors.teal.shade600,
                                onChanged: (value) {
                                  setState(() {
                                    final timeProvider = Provider.of<TimeProvider>(context, listen: false);
                                    if (CountDown.isRunning) {
                                      timeProvider.togglePauseResume();
                                      print("pause");
                                    } else {
                                      timeProvider.togglePauseResume();
                                      timeProvider.startTimer(context);
                                      print("start");
                                    }
                                    CountDown.isRunning = !CountDown.isRunning;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 80),
                        SizedBox(
                          width: 80,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 25,
                              primary: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                final timeProvider = Provider.of<TimeProvider>(context, listen: false);
                                timeProvider.resetTimer();
                                print("stop");
                                CountDown.isRunning = false;
                              });
                            },
                            child: Icon(Icons.stop, color: Colors.white60),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}