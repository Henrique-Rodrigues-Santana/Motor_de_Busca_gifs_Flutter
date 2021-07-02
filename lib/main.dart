import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'UI/GifPage.dart';
import 'UI/HomePage.dart';

void main(){
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(hintColor: Colors.white),
  )
  );
}