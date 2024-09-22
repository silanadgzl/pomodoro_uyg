// import 'package:flutter/material.dart';
// import 'package:pomodoro/providers/background_select.dart';
// import 'package:provider/provider.dart';
// import '../../providers/note_create.dart';
// import 'edit_note_page.dart';
// import 'new_note_page.dart';
// import 'note_home_page.dart';
// bool selected = true;
// class FavoritesPage extends StatefulWidget {
//   const FavoritesPage({super.key});
//
//   @override
//   State<FavoritesPage> createState() => _FavoritesPageState();
// }
//
// class _FavoritesPageState extends State<FavoritesPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<BackgroundSelect>(
//         builder: (context, backgroundSelect, child) {
//       String selectedImage =
//       backgroundSelect.backgroundImages[backgroundSelect.selectedImageIndex];
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent, // Make the background transparent
//         elevation: 2, // Remove the shadow
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(selectedImage),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//       ),
//       body: Consumer2<NoteCreate,BackgroundSelect>(
//         builder: (context, itemModel,backgroundSelect,child) {
//           List<Note> notes = itemModel.notes;
//           String selectedImage = backgroundSelect.backgroundImages[backgroundSelect.selectedImageIndex];
//
//           return Container(
//               decoration: BoxDecoration(
//               image: DecorationImage(
//               image: AssetImage(selectedImage),
//           fit: BoxFit.cover,
//           ),
//           ),
//
//
//            child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () {
//                         selected =!selected;
//                         Navigator.popUntil(context, ModalRoute.withName('/'));
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => NoteHomePage(),
//                             ));
//                         // İlk TextButton'a tıklama işlemi
//                       },
//                       child: Text('Notlarım',style: TextStyle(
//                         color: Colors.black
//                       )),
//                     ),
//                   ),
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () {
//                         selected =!selected;
//                         Navigator.popUntil(context, ModalRoute.withName('/'));
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => FavoritesPage(),
//                             ));
//                         // İkinci TextButton'a tıklama işlemi
//                       },
//                       child: Text('Önemli Notlarım',style: TextStyle(
//                           color: Colors.blue
//                       )),
//                     ),
//                   ),
//                 ],
//               ),
//               Divider(color: Colors.black),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: notes.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     // isStarSelected kontrolü eklenmiş burada
//                     if (notes[index].isStarSelected) {
//                       return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Dismissible(
//                           movementDuration: Duration(seconds: 1000),
//                           key: Key(notes[index].content),
//                           direction: DismissDirection.endToStart,
//                           background: Container(
//                             alignment: Alignment.centerRight,
//                             padding: EdgeInsets.only(right: 5.0),
//                             color: Colors.red,
//                             child: Icon(
//                               Icons.delete,
//                               color: Colors.white,
//                             ),
//                           ),
//                           onDismissed: (direction) {
//                             Provider.of<NoteCreate>(context, listen: false)
//                                 .deleteNote(index);
//                           },
//                           child: Card(
//                             color: backgroundSelect.getColorForIndex(backgroundSelect.selectedImageIndex),
//                             elevation: 5,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15.0),
//                             ),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => EditNotePage(index),
//                                   ),
//                                 );
//                               },
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   ListTile(
//                                     leading: IconButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           // İlgili kartın isStarSelected değerini değiştir
//                                           notes[index].isStarSelected =
//                                               !notes[index].isStarSelected;
//                                         });
//                                       },
//                                       icon: Icon(
//                                         Icons.star,
//                                         color: notes[index].isStarSelected
//                                             ? Colors.yellowAccent.shade700
//                                             : Colors.grey.shade500,
//                                       ),
//                                     ),
//                                     title: Text(notes[index].content,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     } else {
//                       // isStarSelected false ise null döndür ve kart eklenmesin
//                       return SizedBox.shrink();
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ));
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => NewNotePage(),
//             ),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
//     );}}
