import 'package:flutter/material.dart';
import 'package:pomodoro/providers/background_select.dart';
import 'package:provider/provider.dart';

class BackgroundPage extends StatefulWidget {
  const BackgroundPage({super.key});

  @override
  State<BackgroundPage> createState() => _BackgroundPageState();
}

class _BackgroundPageState extends State<BackgroundPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BackgroundSelect>(
      builder: (context, backgroundSelect, child) {
        String selectedImage =
        backgroundSelect.backgroundImages[backgroundSelect.selectedImageIndex];
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent, // Make the background transparent
            elevation: 5, // Remove the shadow
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(selectedImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(selectedImage),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView.builder(
              itemCount: Provider.of<BackgroundSelect>(context).backgroundImages.length,
              itemBuilder: (BuildContext context, int index) {
                bool isSelected = index == backgroundSelect.selectedImageIndex;
                return GestureDetector(
                  onTap: () {
                    // Kart tıklandığında seçilen resmi güncelle
                    Provider.of<BackgroundSelect>(context, listen: false).selectedImageIndex = index;
                  },
                  child: Card(
                    color: isSelected ? Colors.amber : Colors.blueGrey,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(backgroundSelect.backgroundImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 85,
                      width: 100,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
