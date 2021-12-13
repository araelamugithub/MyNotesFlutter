import 'package:mynotes/screens/add_note.dart';
import 'package:mynotes/screens/favorites.dart';
import 'package:mynotes/screens/show_notes.dart';
import 'package:mynotes/screens/wrapper.dart';
import 'package:mynotes/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mynotes/models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {

    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        initialRoute: "/",
        routes: {
        "/" : (context) => Wrapper(),
        "/AddNote" : (context) => AddNote(),
          "/ShowNote" : (context) => ShowNotes(),
          "/Favorites" : (context) => Favorites(),
        },
        //home: Wrapper(),
      ),
    );
  }
}