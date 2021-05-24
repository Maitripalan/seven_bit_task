import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seven_bits_task/login.dart';

void main() async{
   // await Firebase.initializeApp();
     WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      
      
        primarySwatch: Colors.blue,
        


      ),
      home:LoginScreen(),
    );
  }
}




