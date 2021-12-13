import 'package:mynotes/models/user.dart';
import 'package:mynotes/screens/authenticate/authenticate.dart';
import 'package:mynotes/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    if (user == null){
      return Authenticate();
    } else {
      print("User id in wrapper = "+user.uid);
      return Home(uid: user.uid);
    }
    
  }
}