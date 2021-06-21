import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:solution_challenge/domain/repository/remote_source.dart';
import 'package:solution_challenge/features/provider/HomePage_provider.dart';
import 'package:solution_challenge/features/widgets/HomePage_widget.dart';
import 'package:sizer/sizer.dart';
import 'dart:io' show Platform;

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;


class HomePage_Screen extends StatefulWidget {

  @override
  _HomePage_ScreenState createState() => _HomePage_ScreenState();
}

class _HomePage_ScreenState extends State<HomePage_Screen> with AfterLayoutMixin{
HomePageProvider _homePageProvider;
Remote _remote=Remote();

static const platform = MethodChannel('app.channel.shared.data');
String dataShared = 'No data';

/*
void getSharedText() async {
  var sharedData = await platform.invokeMethod('getSharedText');
  if (sharedData != null) {
    setState(() {
      dataShared = sharedData;
    });
   await _remote.setNote(dataShared);

  }
}

 */

@override
void afterFirstLayout(BuildContext context)async {
  _homePageProvider.userRating=1;
  await _homePageProvider.getParkList().then((value) {
    _homePageProvider.checkFilter();
  });

  bool responseLocationsPermission =await Permission.location.isDenied;
/*
  await bg.BackgroundGeolocation.getGeofence("Work").then((value)async {

    print("Work geldi :"+value.identifier+value.latitude.toString()+value.longitude.toString());


  });

 */

  if(Platform.isAndroid)
  {
    if(!responseLocationsPermission){
      await Permission.location.request().then((value) {
        _homePageProvider.isLocationState=true;

      });

    }else{
      _homePageProvider.isLocationState=true;

    }
  }else{
    _homePageProvider.isLocationState=true;
  }

}



@override
  void initState() {



    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _homePageProvider=Provider.of<HomePageProvider>(context);
    return Scaffold(
      body: Stack(children:[
        Visibility(
            visible: _homePageProvider.isLoading&&!_homePageProvider.isLocationState,
            child: Center(child: CircularProgressIndicator())),

        Visibility(
            visible: !_homePageProvider.isLoading&&_homePageProvider.isLocationState,
            child: HomePageWidget(homePageProvider: _homePageProvider))]),
    );
  }





}