import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solution_challenge/domain/models/parks.dart';
import 'package:solution_challenge/domain/repository/remote_source.dart';
import 'package:solution_challenge/domain/repository/repo.dart';

abstract class HomePageProviderAbs{
  onMapCreated(controller);
  getParkList();
  moveCamera();
}

class HomePageProvider with ChangeNotifier implements HomePageProviderAbs{
  GoogleMapController _controller;
  PageController pageController;
  List<Marker> _markers=List<Marker>();
  bool _visibility=false;

  bool get visibility => _visibility;

  set visibility(bool value) {
    _visibility = value;
    notifyListeners();
  }

  List<Marker> get markers => _markers;


  List<Parks> _parkList=List<Parks>();
  int _parkListPosition=0;
  int _preview;




  bool _isLoading=true;


  ProductRepository _productRepository=   ProductRepository();



  bool _detailvisiblity=false;


  double _opacity=0.6;

  bool get detailvisiblity => _detailvisiblity;

  double get opacity => _opacity;

  int get parkListPosition => _parkListPosition;

  bool get isLoading => _isLoading;

  List<Parks> get parkList => _parkList;

  int get preview => _preview;


  GoogleMapController get controller => _controller;


  set controller(GoogleMapController value) {
    _controller = value;
    notifyListeners();
  }

  set parkListPosition(int value) {
    _parkListPosition = value;
    notifyListeners();
  }

  set preview(int value) {
    _preview = value;
    notifyListeners();
  }


  set markers(List<Marker> value) {
    _markers = value;
    notifyListeners();
  }


  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set detailvisiblity(bool value) {
    _detailvisiblity = value;
    notifyListeners();
  }



  set opacity(double value) {
    _opacity = value;
    notifyListeners();
  }


  set parkList(List<Parks> value) {
    _parkList = value;
    notifyListeners();
  }

  onMapCreated(controller){
      _controller=controller;
      notifyListeners();
  }

  moveCamera() {
   controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
            target:LatLng(double.parse(parkList[pageController.page.toInt()].coords1),double.parse(parkList[pageController.page.toInt()].coords2)),
            zoom: 14,bearing: 45,tilt: 45
        )));
  }

 Future getParkList()async{
    await _productRepository.getParkList().then((value) {
    parkList=value;
    print(parkList[0].coords1.toString()+" : "+parkList[0].coords2.toString());
    isLoading=false;
    });
    notifyListeners();
  }

  scroll(){
    if(pageController.page.toInt()!=preview){
      preview=pageController.page.toInt();
      moveCamera();
      notifyListeners();
    }

  }


}