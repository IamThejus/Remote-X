import 'package:flutter/material.dart';
import 'package:universal_remote/screen_ac_remote.dart';
import 'package:universal_remote/screen_fan_remote.dart';
import 'screen_home.dart';


void main(){
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      ),
      home:HomeScreen(),
      routes: {
        "fan_screen":(ctx){
          return FanScreen();
        }
        ,
        "ac_screen":(ctx){
          return AcRemotePage();
          //return AcScreen();
        }
      },
    );
  }
}

