import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  _homePageProvider.checkFilter();

}


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