import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[200],
      child: Center(
        child: SpinKitWave(
          color: Colors.black,
          size: 70.0,
        ),
      ),
    );
  }
}