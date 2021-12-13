
class Notes {
  String userId;
  String title;
  String body;
  bool isFavorite;

  Notes({ required this.userId, required this.title, required this.body, required this.isFavorite});

  Map<String, dynamic> toMap(){
    return ({
      "userId" : userId,
      "title" : title,
      "body" : body,
      "isFavorite" : isFavorite
    });
  }
}