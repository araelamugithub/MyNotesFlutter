import 'package:flutter/material.dart';
import 'package:mynotes/models/notes.dart';
import 'package:mynotes/services/mongodb.dart';

class ShowNotes extends StatefulWidget {
  const ShowNotes({Key? key}) : super(key: key);

  @override
  _ShowNotesState createState() => _ShowNotesState();
}

class _ShowNotesState extends State<ShowNotes> {
  String title = '';
  String userId = '';
  String body = '';
  bool isFavorite = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    MongoDb mongoDb = MongoDb();
    var routeData;
    routeData = ModalRoute.of(context)!.settings.arguments;

    final Notes note =  routeData['notes'];
    isFavorite = note.isFavorite;
    titleController = TextEditingController(text: note.title);
    bodyController = TextEditingController(text: note.body);

    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        title: Text("Your Note"),
        backgroundColor: Colors.blueGrey[400],
        actions: [
          IconButton(
            onPressed: (){
              if(isFavorite == true){
                scaffold.showSnackBar(
                  SnackBar(
                    content: const Text('Removed From favorites'),
                    action: SnackBarAction(label: 'close', onPressed: scaffold.hideCurrentSnackBar),
                  ),
                );
                setState(() {
                  isFavorite = isFavorite == true ? false : true;
                });
              } else {
                scaffold.showSnackBar(
                  SnackBar(
                    content: const Text('Added to favorites'),
                    action: SnackBarAction(label: 'close', onPressed: scaffold.hideCurrentSnackBar),
                  ),
                );
                setState(() {
                  isFavorite = isFavorite == true ? false : true;
                });
              }
              Notes notesFav =  routeData['notes'];
              setState(() {
                title = titleController.text;
                body = bodyController.text;
                userId = notesFav.userId;
              });
              Notes note = Notes(userId: userId, title: title, body: body, isFavorite: isFavorite);
              mongoDb.updateNotes(routeData['objectId'], note);
              print("Favorites updated successfully");
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            icon : Icon(
              isFavorite == true ? Icons.favorite : Icons.favorite_border,
              color: Colors.black,
            ),
          ),
          FlatButton.icon(
            icon: Icon(Icons.delete),
            label: Text("delete"),
            onPressed: (){
              mongoDb.deleteNotes(routeData['objectId']);
              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
          Notes notes =  routeData['notes'];
          setState(() {
            title = titleController.text;
            body = bodyController.text;
            userId = notes.userId;
            isFavorite = notes.isFavorite;
          });
          Notes note = Notes(userId: userId, title: title, body: body, isFavorite: isFavorite);
          mongoDb.updateNotes(routeData['objectId'], note);
          print("Notes updated successfully");
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
        label: Text("Update Note", style: TextStyle(color: Colors.black,),),
        icon: Icon(Icons.update, color: Colors.black,),
      ),
    );
  }
}
