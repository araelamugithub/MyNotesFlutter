

import 'package:flutter/material.dart';
import 'package:mynotes/models/notes.dart';
import 'package:mynotes/screens/home/home.dart';
import 'package:mynotes/services/mongodb.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  //String routeData = "";
  Map routeData = {};
  MongoDb mongo = MongoDb();
  String title = '';
  String userId = '';
  String body = '';
  bool isFavorite = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  addNote(Notes notes){
    mongo.addNotes(notes);
    print("Notes added succesfully");
  }

  @override
  Widget build(BuildContext context) {
    routeData = ModalRoute.of(context)!.settings.arguments as Map;
    print("Addnotes userId = "+ routeData['userId']);
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        title: Text("Add New Note", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.blueGrey[400],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          children: [
            SizedBox(height: 8.0),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                border: InputBorder.none,
                hintText: "Note Title",
              ),
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Divider(thickness: 1, color: Colors.black,),
            SizedBox(height: 8.0),
            Expanded(
              child: TextField(
                controller: bodyController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  border: InputBorder.none,
                  hintText: "Type your notes here",
                ),
                style: TextStyle(fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueGrey[400],
        onPressed: (){
          setState(() {
            title = titleController.text;
            body = bodyController.text;
            userId = routeData['userId'];
            isFavorite = false;
          });
          Notes note = Notes(userId: userId, title: title, body: body, isFavorite: isFavorite);
          addNote(note);
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
        label: Text("Save Note", style: TextStyle(color: Colors.black,),),
        icon: Icon(Icons.save, color: Colors.black,),
      ),

    );
  }
}
