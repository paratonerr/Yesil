import 'package:after_layout/after_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:solution_challenge/features/provider/HomePage_provider.dart';
import 'package:solution_challenge/features/screen/HomePage_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solution_challenge/features/screen/account/login_screen.dart';
import 'package:solution_challenge/features/screen/account/profil_screen.dart';
import 'package:solution_challenge/features/screen/initLanguage_screen.dart';
import 'package:solution_challenge/features/screen/mission_carousel.dart';
import 'package:solution_challenge/features/screen/onboarding_screen.dart';
import 'package:solution_challenge/features/screen/testlaunchmap.dart';
import 'package:solution_challenge/utils/SlideLeftRoutes.dart';
import 'package:solution_challenge/utils/bloc_localization.dart';
import 'features/screen/HomePage_screen.dart';
import 'package:sizer/sizer.dart';


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



  @override
  void afterFirstLayout(BuildContext context) async{
  }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider<BlocLocalization>(
      create:(_)=> BlocLocalization(),
      child: BlocBuilder<BlocLocalization, Locale>(
        builder:(context,locale){
          return  LayoutBuilder(
            builder: (context,constraints){
              return  OrientationBuilder(
                  builder: (context,orientation){
                    SizerUtil().init(constraints, orientation);
                    return  MaterialApp(
                    locale: locale,
                    debugShowCheckedModeBanner: false,
                    supportedLocales: [Locale("en"), Locale("tr")],
                    localizationsDelegates: [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    theme: ThemeData(
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                    ),
                    routes: {
                      "/": (context)=>initLanguage()
                    },

                    onGenerateRoute:(settings){
                      switch(settings.name){
                        case "/login":
                          return SlideLeftRoute(page: LoginScreen());
                          break;

                        case "/home":
                          return SlideLeftRoute(page: HomePage_Screen());
                          break;

                        case "/onboard_mission":
                          return SlideLeftRoute(page: OnBoardingMissionPage());
                          break;
                        case "/profil":
                          return SlideLeftRoute(page: Profil_Screen());
                          break;
                        case "/initial_language":
                          return SlideLeftRoute(page: initLanguage());
                          break;
                        default:
                          return SlideLeftRoute(page: initLanguage());
                          break;
                      }
                    },
                  );
                },
              );
            },
          );
        }
      ),
    );
  }

}

