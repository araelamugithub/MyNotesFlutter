import 'package:flutter/material.dart';
import 'package:mynotes/models/notes.dart';
import 'package:mynotes/services/mongodb.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

  Map routeData = {};
  final MongoDb mongoDb = MongoDb();

  getFavoritesForNotes(String userId) async {
    final Notes notes = Notes(userId: userId, title: '', body: '', isFavorite: false);
    final notesData = await mongoDb.getFavoriteNotes(notes);
    //print(notesData.runtimeType);
    return notesData;
  }


  @override
  Widget build(BuildContext context) {

    routeData = ModalRoute.of(context)!.settings.arguments as Map;
    print("User id in Favorites screen = "+ routeData["userId"]);


    return Container(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[200],
        appBar: AppBar(
          title: Text('Favorites', style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.blueGrey[400],
          elevation: 0.0,
        ),
        body: FutureBuilder(
          future: getFavoritesForNotes(routeData["userId"]),
          builder: (context, noteData) {
            if (noteData.hasData) {
              switch (noteData.connectionState) {
                case ConnectionState.waiting:
                  {
                    return Center(child: CircularProgressIndicator());
                  }
                case ConnectionState.done:
                  {
                    if (noteData.data == Null) {
                      return Center(child: Text(
                        "You don't have any favorites to display, Add one.", style: TextStyle(fontSize: 18),));
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: (noteData.data as List<Map<String, dynamic>>).length,
                          itemBuilder: (context, index) {
                            var lists = noteData.data as List<Map<String, dynamic>>;
                            String title = lists[index]['title'];
                            String body = lists[index]['body'];
                            return Card(
                              //elevation: 8.0,
                              color: Colors.blueGrey[400],
                              child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.red,
                                            style: BorderStyle.solid,
                                          )
                                      ),
                                      child: ListTile(
                                        onTap: (){
                                          Notes note = new Notes(userId: lists[index]['userId'], title: lists[index]['title'], body: lists[index]['body'], isFavorite: lists[index]["isFavorite"]);
                                          Navigator.pushNamed(context, "/ShowNote", arguments: {
                                            'notes' : note,
                                            'objectId' : lists[index]['_id'],
                                          });
                                        },
                                        title: Text("Title : "+title, style: TextStyle(fontWeight: FontWeight.bold,),),
                                        subtitle: Text("Description : "+body, style: TextStyle(color: Colors.black),),
                                      ),
                                    ),
                                  ]
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }
                default : {
                  return Center(child: Text(
                    "You don't have any favorites to display, Add one.", style: TextStyle(fontSize: 18),));
                }
              }
            } else {
              return Center(child: Text(
                "You don't have any favorites to display, Add one.", style: TextStyle(fontSize: 18),));
            }
          },
        ),
      ),
    );
  }
}
