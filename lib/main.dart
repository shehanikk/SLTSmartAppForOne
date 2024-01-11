import 'package:finalsmartterraapp/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyCxJmDcTECvXMk_9-RTKw8ck-zy7douA4o',
      appId: '1:149260196149:android:b1c4054fa046469f1ad47c',
      messagingSenderId: '149260196149',
      projectId: 'esp32-to-firebase-48d58',
      authDomain: 'esp32-to-firebase-48d58.firebaseapp.com',
      databaseURL: 'https://esp32-to-firebase-48d58-default-rtdb.asia-southeast1.firebasedatabase.app/', // IMPORTANT!
      storageBucket: 'esp32-to-firebase-48d58.appspot.com',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const NewSplashScreen(),
    );
  }
}
