import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge/domain/repository/remote_source.dart';
import 'package:solution_challenge/features/provider/HomePage_provider.dart';
import 'package:solution_challenge/features/widgets/HomePage_widget.dart';


class HomePage_Screen extends StatefulWidget {

  @override
  _HomePage_ScreenState createState() => _HomePage_ScreenState();
}

class _HomePage_ScreenState extends State<HomePage_Screen> with AfterLayoutMixin{
HomePageProvider _homePageProvider;

@override
void afterFirstLayout(BuildContext context)async {
  _homePageProvider.userRating=1;
  await _homePageProvider.getParkList().then((value) {
    _homePageProvider.checkFilter();
  });

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
            visible: _homePageProvider.isLoading,
            child: Center(child: CircularProgressIndicator())),

        Visibility(
            visible: !_homePageProvider.isLoading,
            child: HomePageWidget(homePageProvider: _homePageProvider,))]),
    );
  }





}