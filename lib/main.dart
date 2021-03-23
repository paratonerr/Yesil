import 'package:after_layout/after_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:solution_challenge/features/provider/HomePage_provider.dart';
import 'package:solution_challenge/features/screen/HomePage_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solution_challenge/features/screen/account/login_screen.dart';
import 'package:solution_challenge/features/screen/onboarding_screen.dart';
import 'package:solution_challenge/utils/SlideLeftRoutes.dart';


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

class MyApp extends StatefulWidget {
  // This widget is the root of your application.



  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with AfterLayoutMixin<MyApp> {
  Future<double> _getSavedWeightNote() async {
    String sharedData = await const MethodChannel('app.channel.shared.data')
        .invokeMethod("getSavedNote");
    if (sharedData != null) {
      int firstIndex = sharedData.indexOf(new RegExp("[0-9]"));
      int lastIndex = sharedData.lastIndexOf(new RegExp("[0-9]"));
      if (firstIndex != -1) {
        String number = sharedData.substring(firstIndex, lastIndex + 1);
        double num = double.parse(number, (error) => null);
        return num;
      }
    }
    return null;
  }


  @override
  void afterFirstLayout(BuildContext context) async{
  }
  @override
  void initState() {
    // TODO: implement initState
     _getSavedWeightNote();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
        routes: {
        "/": (context)=>HomePage()
        },

        onGenerateRoute:(settings){
        switch(settings.name){
          case "/login":
            return SlideLeftRoute(page: LoginScreen());
            break;
          case "/home":
            return SlideLeftRoute(page: HomePage());
            break;
          default:
            return SlideLeftRoute(page: LoginScreen());
            break;
        }
        },
    );
  }

}

