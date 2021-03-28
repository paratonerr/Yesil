import 'package:google_maps_flutter/google_maps_flutter.dart';

class Parks{
  String description;
  String title;
  String photo;
  LatLng coords;
  String coords1;
  String coords2;
  bool kosuPark=false;
  bool engellidostu=false;
  bool kultureloge=false;
  bool otopark=false;
  bool oturmaalani=false;
  bool tuvalet=false;
  bool yemeicme=false;

  Parks({this.coords,this.description,this.photo,this.title,this.coords2,this.coords1});


  Parks.fromJsonMap(Map<String, dynamic> map):
        description = map["description"],
        title = map["title"],
        photo = map["photo"],
        coords1 = map["coords1"],
        coords2 = map["coords2"],
        otopark = map["otopark"],
        tuvalet = map["tuvalet"],
        yemeicme = map["yemeicme"],
        oturmaalani = map["oturmaalani"],
        kultureloge = map["kultureloge"],
        engellidostu = map["engellidostu"],
        kosuPark = map["sporalani"];

}

final List<Parks> parkList=[
  Parks(
    description: "park1",
    title: "park1",
    photo: "https://cdn.nerde.co/macka-demokrasi-parki-1518084998.jpeg",
    coords: LatLng(41.0393954,28.9941087)
  ),Parks(
      description: "park1",
      title: "park2",
      photo: "https://cdn.nerde.co/macka-demokrasi-parki-1518084998.jpeg",
      coords: LatLng(41.0393954,28.9641087)
  ),
  Parks(
      description: "park1",
      title: "park3",
      photo: "https://cdn.nerde.co/macka-demokrasi-parki-1518084998.jpeg",
      coords: LatLng(41.0393954,28.9241087)
  ),

];





