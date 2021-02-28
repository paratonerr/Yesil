import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge/domain/repository/remote_source.dart';
import 'package:solution_challenge/features/provider/HomePage_provider.dart';
import 'package:solution_challenge/features/widgets/HomePage_widget.dart';
class HomePage extends StatefulWidget {



  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin{
HomePageProvider _homePageProvider;

@override
void afterFirstLayout(BuildContext context)async {

  await _homePageProvider.getParkList();

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

        HomePageWidget(homePageProvider: _homePageProvider,)]),
    );
  }





}