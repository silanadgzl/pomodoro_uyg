import 'package:flutter/material.dart';
import 'package:pomodoro/providers/time_counter.dart';
import 'package:pomodoro/sound.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/note_create.dart';
import 'providers/background_select.dart';
import 'ui/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int savedIndex = prefs.getInt('selectedImageIndex') ?? 0;

  // Sound sınıfını başlatın
  await Sound.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteCreate()),
        ChangeNotifierProvider(create: (_) => BackgroundSelect()..selectedImageIndex = savedIndex),
        ChangeNotifierProvider(create: (_) => TimeProvider()),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Debug yazısını kaldırmak için bu satırı ekleyin
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.amber,
        ),
        useMaterial3: true,
      ),
      home: FutureBuilder<void>(
        future: initSharedPreferences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return HomePage();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<void> initSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Burada SharedPreferences'tan verileri çekebilir ve ItemModel sınıfını güncelleyebilirsiniz.
  }
}
