import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_week10/pages/register_form_page.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register Form',
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RegisterFormPage(),
    );
  }
}
