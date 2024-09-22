import 'package:flutter/material.dart';
import 'package:pomodoro/ui/notification_sound.dart';
import 'package:pomodoro/ui/pages/background_page.dart';
import 'package:pomodoro/providers/background_select.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ayarlar",style: TextStyle(fontWeight: FontWeight.w400)),backgroundColor: Colors.blue.shade100),
      body: Consumer<BackgroundSelect>(
          builder: (context, backgroundSelect, child) {
            String selectedImage = backgroundSelect.backgroundImages[backgroundSelect.selectedImageIndex];

            return Container(
                decoration: BoxDecoration(
                image: DecorationImage(
                image: AssetImage(selectedImage),
            fit: BoxFit.cover,
            ),
            ),
        child: ListView(
          children: [
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => BackgroundPage()));
              },
              child: Card(
                color: backgroundSelect.getColorForIndex(backgroundSelect.selectedImageIndex),
                margin: EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 20),
                child: Container(margin: EdgeInsets.only(left: 20),alignment: AlignmentDirectional.centerStart,width: 100,height: 80,child: Text("Arka Plan")),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationSound()));
              },
              child: Card(
                color: backgroundSelect.getColorForIndex(backgroundSelect.selectedImageIndex),
                margin: EdgeInsets.only(left: 10,right: 10),
                child: Container(margin: EdgeInsets.only(left: 20),alignment: AlignmentDirectional.centerStart,width: 100,height: 80,child: Text("Ses")),
              ),
            ),
          ],
        ));
  }),
    );
  }
}

