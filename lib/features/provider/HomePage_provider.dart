import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:solution_challenge/domain/models/parks.dart';
import 'package:solution_challenge/domain/repository/remote_source.dart';
import 'package:solution_challenge/domain/repository/repo.dart';
import 'package:solution_challenge/features/widgets/appexpansion.dart';
import 'package:sizer/sizer.dart';
import 'dart:ui' as ui;


abstract class HomePageProviderAbs{
  onMapCreated(controller);
  getParkList();
  setRating(String parkname,var uid ,double rating);
  moveCamera();
}

class HomePageProvider with ChangeNotifier implements HomePageProviderAbs{
  GoogleMapController _controller;
  PageController _pageController;
  PanelController _panelController=PanelController() ;

  PanelController get panelController => _panelController;

  set panelController(PanelController value) {
    _panelController = value;
    notifyListeners();
  }

  PageController get pageController => _pageController;


  GlobalKey<AppExpansionTileState> _expansionTileList=GlobalKey<AppExpansionTileState>();


  GlobalKey<AppExpansionTileState> get expansionTileList => _expansionTileList;



  PageController minscrollExtend;
  List<Marker> _markers=List<Marker>();

  List<String> filter=List<String>();



  List<Marker> get markers => _markers;


  List<Parks> _parkList=List<Parks>();
  List<Parks> _park=List<Parks>();

  List<Parks> get park => _park;

  set park(List<Parks> value) {
    _park = value;
    notifyListeners();
  }

  int _parkListPosition=0;
  int _preview;
  double _draggablePadding=6.0.h;


  double get draggablePadding => _draggablePadding;

  set draggablePadding(double value) {
    _draggablePadding = value;
  }

  bool _isLoading=true;
  bool _spor=false;
  bool _engellidostu=false;
  bool _yemek=false;
  bool _wc=false;
  bool _kultureloge=false;
  bool _otopark=false;
  bool _oturmaalani=false;
  bool _expansionState=false;


  bool get panelCheck => _panelCheck;

  set panelCheck(bool value) {
    _panelCheck = value;
    notifyListeners();
  }

  bool _panelCheck=false;

  bool get expansionState => _expansionState;



  double _ortRating;
  double _userRating=1;

  double get userRating => _userRating;

  set userRating(double value) {
    _userRating = value;
    notifyListeners();
  }

  double get ortRating => _ortRating;

  set ortRating(double value) {
    _ortRating = value;
    notifyListeners();
  }

  bool get spor => _spor;

  set spor(bool value) {
    _spor = value;
    notifyListeners();
  }


  set expansionState(bool value) {
    _expansionState = value;
    notifyListeners();
  }

  ProductRepository _productRepository=   ProductRepository();



  bool _detailvisiblity=false;


  double _opacity=0.1;

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
  }

  set preview(int value) {
    _preview = value;
    notifyListeners();
  }


  set markers(List<Marker> value) {
    _markers = value;
    notifyListeners();
  }

  set expansionTileList(GlobalKey<AppExpansionTileState> value) {
    _expansionTileList = value;
    notifyListeners();
  }

  set pageController(PageController value) {
    _pageController = value;
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

  onMapCreated(controller)async{
    BitmapDescriptor  mapMarker;
      await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(40, 40,),devicePixelRatio: 10), "asset/markeragac.png").then((value) {
      mapMarker=value;
    });
    _controller=controller;
    List.generate(parkList.length, (index) async{
      LatLng coords=LatLng(double.parse(parkList[index].coords1),double.parse(parkList[index].coords2));
      markers.add(Marker(
          onTap: ()async {
            moveCameraWithMarker(double.parse(parkList[index].coords1), double.parse(parkList[index].coords2));
            parkListPosition=index;
           await panelController.open();
          },
          icon: mapMarker,
          markerId: MarkerId(parkList[index].title),
          infoWindow: InfoWindow(title: parkList[index].title, snippet: parkList[index].description),
          position:coords));

    });

    notifyListeners();
  }

  moveCamera() {
   controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
            target:LatLng(double.parse(parkList[pageController.page.toInt()].coords1),double.parse(parkList[pageController.page.toInt()].coords2)),
            zoom: 14,bearing: 45,tilt: 45
        )));
  }

  moveCameraWithMarker(cords1,cords2) {
    controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
            target:LatLng(cords1,cords2),
            zoom: 14,bearing: 45,tilt: 45
        )));
  }

 Future getParkList()async{
    await _productRepository.getParkList().then((value) {
    park=value;
    isLoading=false;

    });
    notifyListeners();
  }

  Future setRating(String parkname,var uid ,double rating)async{
    await _productRepository.setRating(parkname, uid, rating);
  }
  Future getRating(String parkname)async{

    var d=await _productRepository.getRating(parkname);
    ortRating=d.isNaN==true?1:d;
    print(ortRating.toString()+"provider");

    notifyListeners();

  }

  Future getUserRating(String parkname,var uid)async{
   var d= await _productRepository.getUserRating(parkname, uid);
   print(d.toString()+"user provider");
   if(d!=null){
     userRating=d;
   }

notifyListeners();

  }


  scroll(){
    if(pageController.page.toInt()!=preview){
      preview=pageController.page.toInt();
      moveCamera();
      notifyListeners();
    }

  }




  checkMenuVisibility(){
     if(panelCheck==true){
       return false;
    } else{
      return true;
    }
    notifyListeners();
  }

  bool get engellidostu => _engellidostu;

  set engellidostu(bool value) {
    _engellidostu = value;
    notifyListeners();
  }

  bool get yemek => _yemek;

  set yemek(bool value) {
    _yemek = value;
    notifyListeners();
  }

  bool get wc => _wc;

  set wc(bool value) {
    _wc = value;
    notifyListeners();
  }

  bool get kultureloge => _kultureloge;

  set kultureloge(bool value) {
    _kultureloge = value;
    notifyListeners();
  }

  bool get otopark => _otopark;

  set otopark(bool value) {
    _otopark = value;
    notifyListeners();
  }

  bool get oturmaalani => _oturmaalani;

  set oturmaalani(bool value) {
    _oturmaalani = value;
    notifyListeners();
  }
  checkFilter2() {
    park.clear();

    park.addAll(parkList.where((element) => element.otopark==otopark&&element.tuvalet==wc&&element.kultureloge==kultureloge&&element.engellidostu==engellidostu&&element.oturmaalani==oturmaalani&&element.yemeicme==yemek));

    if(park.isNotEmpty){
      park.addAll(parkList);

    }

    if(park.isEmpty){
      park.addAll(parkList);
    }

    print(park.length);

    notifyListeners();

  }

  checkFilter(){
    parkList.clear();
    ///eğer tüm koşullar true ise
if(otopark==true||oturmaalani==true||engellidostu==true||kultureloge==true||spor==true||wc==true||yemek==true){
  if(otopark==true){
    List.generate(park.length, (index) {
      if(park[index].kosuPark==true){
        parkList.add(park[index]);
        notifyListeners();
      }
    });
  }  if(oturmaalani==true){
    List.generate(park.length, (index) {
      if(park[index].oturmaalani==true){
        parkList.add(park[index]);
        notifyListeners();
      }
    });
  }  if(engellidostu==true){
    List.generate(park.length, (index) {
      if(park[index].engellidostu==true){
        parkList.add(park[index]);
        notifyListeners();
      }
    });
  }if(kultureloge==true){
    List.generate(park.length, (index) {
      if(park[index].kultureloge==true){
        parkList.add(park[index]);
        notifyListeners();
      }
    });
  }if(spor==true){
    List.generate(park.length, (index) {
      if(park[index].kosuPark==true){
        parkList.add(park[index]);
        notifyListeners();
      }
    });
  }if(wc==true){
    List.generate(park.length, (index) {
      if(park[index].tuvalet==true){
        parkList.add(park[index]);
        notifyListeners();
      }
    });
  }
  if(yemek==true){
    List.generate(park.length, (index) {
      if(park[index].yemeicme==true){
        parkList.add(park[index]);
        notifyListeners();
      }
    });
  }
} else{
      List.generate(park.length, (index) {
          parkList.add(park[index]);
      });
    }


    notifyListeners();
  }
}