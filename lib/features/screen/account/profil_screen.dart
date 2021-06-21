import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge/features/provider/profile_provider.dart';
import 'package:solution_challenge/features/widgets/profile_widget.dart';
import 'package:solution_challenge/utils/Routes.dart';
import 'package:solution_challenge/utils/app_localizations.dart';
import 'package:sizer/sizer.dart';

class Profil_Screen extends StatefulWidget {
  @override
  _Profil_ScreenState createState() => _Profil_ScreenState();
}

class _Profil_ScreenState extends State<Profil_Screen>with TickerProviderStateMixin,AfterLayoutMixin {
  FirebaseAuth _auth;
  User _user;
  GoogleSignIn _googleSignIn=GoogleSignIn();
  Profile_Provider _profile_provider;

  TabController tabController;
  PageController pageController;
  List<String> rozet;
  List<String> rozetName;





  @override
  void initState() {
    // TODO: implement initState
    _auth=FirebaseAuth.instance;
     rozet=List<String>();
     rozetName=List<String>();

    rozet.add("asset/1.png");
    rozet.add("asset/2.png");
    rozet.add("asset/3.png");
    rozet.add("asset/4.png");
    rozet.add("asset/5.png");
    rozet.add("asset/6.png");
    rozet.add("asset/7.png");
    rozet.add("asset/8.png");
    rozet.add("asset/9.png");
    rozet.add("asset/10.png");
    rozet.add("asset/11.png");
    rozet.add("asset/12.png");
    rozet.add("asset/13.png");
    rozet.add("asset/14.png");
    rozet.add("asset/15.png");

    rozetName.add("title1");
    rozetName.add("title2");
    rozetName.add("title3");
    rozetName.add("title4");
    rozetName.add("title5");
    rozetName.add("title6");
    rozetName.add("title7");
    rozetName.add("title8");
    rozetName.add("title9");
    rozetName.add("title10");
    rozetName.add("title11");
    rozetName.add("title12");
    rozetName.add("title13");
    rozetName.add("title14");
    rozetName.add("title15");

    _user=_auth.currentUser;

    pageController=PageController(initialPage: 1);
    tabController=TabController(length: 2, vsync: this);


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _profile_provider=Provider.of<Profile_Provider>(context);
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: ()async=> false,
      child: Scaffold(
        body: _profile_provider.taskStateLoading==true?Profile_Widget(profile_provider: _profile_provider,tabController: tabController,):Center(child: CircularProgressIndicator())
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async{
    // TODO: implement afterFirstLayout
    _profile_provider.taskStateLoading=false;

    _profile_provider.getTaskPhoto(uid: _user.uid).then((value) {
      setState(() {

      });
    });
     print(_profile_provider.photoList.toString());
    await _profile_provider.getLevel(uid: _user.uid);




  }
}
