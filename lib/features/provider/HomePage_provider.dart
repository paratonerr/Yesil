import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solution_challenge/domain/models/parks.dart';
import 'package:solution_challenge/domain/repository/remote_source.dart';
import 'package:solution_challenge/domain/repository/repo.dart';
import 'package:solution_challenge/features/widgets/appexpansion.dart';

abstract class HomePageProviderAbs{
  onMapCreated(controller);
  getParkList();
  setRating(String parkname,var uid ,double rating);
  moveCamera();
}

class HomePageProvider with ChangeNotifier implements HomePageProviderAbs{
  GoogleMapController _controller;
  PageController _pageController;

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




  bool _isLoading=true;
  bool _spor=false;
  bool _cocukPark=false;
  bool _yemek=false;
  bool _wc=false;
  bool _bisiklet=false;
  bool _kosuPark=false;
  bool _ethernet=false;

  double _ortRating;
  double userRating=1;

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
    BitmapDescriptor  mapMarker=await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "asset/markeragac.png");

    _controller=controller;
      parkList.forEach((element) async{
        LatLng coords=LatLng(double.parse(element.coords1),double.parse(element.coords2));
          print("2132"+element.coords1);
          markers.add(Marker(
            icon: mapMarker,
              markerId: MarkerId(element.title),
              infoWindow: InfoWindow(title: element.title, snippet: element.description),
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
   userRating =d.isNaN==true?1:d;

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
    if(opacity>=0.9){
      return false;
    }else{
      return true;
    }
  }

  bool get cocukPark => _cocukPark;

  set cocukPark(bool value) {
    _cocukPark = value;
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

  bool get bisiklet => _bisiklet;

  set bisiklet(bool value) {
    _bisiklet = value;
    notifyListeners();
  }

  bool get kosuPark => _kosuPark;

  set kosuPark(bool value) {
    _kosuPark = value;
    notifyListeners();
  }

  bool get ethernet => _ethernet;

  set ethernet(bool value) {
    _ethernet = value;
    notifyListeners();
  }

  checkFilter(){
    parkList.clear();
    ///eğer tüm koşullar true ise
    if(kosuPark==true){

      if(kosuPark==true){
        List.generate(park.length, (index) {
          if(park[index].kosuPark==true){
            parkList.add(park[index]);
            notifyListeners();
          }
        });
      }

    }else{
      List.generate(park.length, (index) {
          parkList.add(park[index]);
      });
    }


    notifyListeners();
  }
}