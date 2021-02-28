import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge/features/provider/HomePage_provider.dart';
import 'package:solution_challenge/features/screen/HomePage_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (BuildContext context)=>HomePageProvider())
      ],
      child: MyApp() ,
      )

     );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
        home:HomePage()

    );
  }
}

