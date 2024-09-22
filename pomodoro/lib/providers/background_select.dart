// background_select.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundSelect extends ChangeNotifier {
  int _selectedImageIndex = 0; // Varsayılan olarak ilk resmi seçin
  Color _backgroundColor = Colors.green; // Varsayılan arka plan rengi

  List<String> backgroundImages = [
    'assets/a1.png',
    'assets/a2.png',
    'assets/a3.png',
    'assets/a4.png',
    'assets/a5.png',
    'assets/a6.png',
    'assets/a7.png',
    'assets/a8.png',
    'assets/a9.png',
    'assets/a10.png',
    'assets/a11.png',
    'assets/a12.png',

  ];

  int get selectedImageIndex => _selectedImageIndex;
  Color get backgroundColor => _backgroundColor;

  BackgroundSelect() {
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedIndex = prefs.getInt('selectedImageIndex') ?? 0;
    _selectedImageIndex = savedIndex;
    _setTheme(getColorForIndex(savedIndex));
    notifyListeners();
  }

  set selectedImageIndex(int index) {
    _selectedImageIndex = index;
    _setTheme(getColorForIndex(index));

    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('selectedImageIndex', index);
    });

    notifyListeners();
  }

  void _setTheme(Color color) {
    _backgroundColor = color;
    notifyListeners();
  }

  Color getColorForIndex(int index) {
    switch (index) {
      case 0:
        return Colors.lightGreen;
      case 1:
        return Colors.blue.shade100
        ;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blueGrey.shade100;
      case 4:
        return Colors.brown.shade100;
      case 5:
        return Colors.yellow.shade300;
      case 6:
        return Colors.teal.shade700;
      case 7:
        return Colors.yellow.shade300;
      case 8:
        return Colors.pink.shade100;
      case 9:
        return Colors.brown.shade100;
      case 10:
        return Colors.grey.shade100;
      case 11:

      default:
        return Colors.indigo.shade300;
    }
  }
}
