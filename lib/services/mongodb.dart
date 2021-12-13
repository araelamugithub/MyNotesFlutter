import 'package:mongo_dart/mongo_dart.dart';
import 'package:mynotes/models/notes.dart';

class MongoDb{

  //add notes
  void addNotes(Notes notes) async{
    final Db db = Db('mongodb://10.0.2.2:27017/notes');
    await db.open();
    DbCollection collection = db.collection('notesdata');
    await collection.insert(notes.toMap());
    await db.close();
  }

  //find notes
  Future<dynamic> getNotes(Notes notes) async{
    final Db db = Db('mongodb://10.0.2.2:27017/notes');
    await db.open();
    DbCollection collection = db.collection('notesdata');
    var result = await collection.find(where.eq('userId', notes.userId)).toList();
    if(result.length == 0){
      await db.close();
      return null;
    }else{
      await db.close();
      return result;
    }
  }

  //find Favorite notes
  Future<dynamic> getFavoriteNotes(Notes notes) async{
    final Db db = Db('mongodb://10.0.2.2:27017/notes');
    await db.open();
    DbCollection collection = db.collection('notesdata');
    var result = await collection.find(where.eq('userId', notes.userId).eq('isFavorite', true)).toList();
    if(result.length == 0){
      await db.close();
      return null;
    }else{
      await db.close();
      return result;
    }
  }

  //update notes
  void updateNotes(ObjectId objectId, Notes notes) async{
    final Db db = Db('mongodb://10.0.2.2:27017/notes');
    await db.open();
    DbCollection collection = db.collection('notesdata');
    Map<String, dynamic>? dataToUpdate = await collection.findOne(where.eq('_id', objectId));
    await collection.update(dataToUpdate, notes.toMap());
    await db.close();
  }

  //delete notes
  void deleteNotes(ObjectId objectId) async {
    print("Deleted Object ID = "+objectId.toString());
    final Db db = Db('mongodb://10.0.2.2:27017/notes');
    await db.open();
    DbCollection collection = db.collection('notesdata');
    await collection.remove(await collection.findOne(where.eq('_id', objectId)));
    await db.close();
  }

}