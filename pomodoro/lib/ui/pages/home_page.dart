import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/providers/background_select.dart';
import 'package:pomodoro/settings_page.dart';
import 'package:pomodoro/ui/pages/count_down_page.dart';
import 'package:pomodoro/ui/pages/hour_page.dart';
import 'package:provider/provider.dart';
import 'note_home_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0; // static olmamalı, çünkü widget'in durumu değişebilir

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BackgroundSelect>(
        builder: (context, backgroundSelect, child) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundSelect.backgroundImages[backgroundSelect.selectedImageIndex]),
                fit: BoxFit.cover,
              ),
            ),
            child: IndexedStack(
              index: currentPageIndex,
              children: [
                CountDown(),
                HourPage(),
                NoteHomePage(),
                SettingsPage(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blue.shade100,
        backgroundColor: Colors.indigo.shade200,
        items: const <Widget>[
          Icon(Icons.home_outlined, size: 35),
          Icon(Icons.access_time_rounded, size: 35),
          Icon(Icons.edit_note_sharp, size: 35),
          Icon(Icons.settings_outlined, size: 35),

        ],
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        index: currentPageIndex,

      ),
    );
  }
}
