import 'package:solution_challenge/domain/models/parks.dart';
import 'package:solution_challenge/domain/repository/remote_source.dart';

abstract class ProductRepositoryAbs{
Future getParkList();
Future setRating(String parkname,var uid,double rating);
Future<double> getRating(String parkname);
Future<double> getUserRating(String parkname,var uid);
Future setActiviy(idenfitier,state);


}

class ProductRepository implements ProductRepositoryAbs{
  Remote _remote=Remote();

  @override
  Future<List<Parks>> getParkList() async{
   try{
     print("product repo: ");

     List<Parks> parkList=await _remote.getParkList();

    print("product repo: "+ parkList.toString());


  return parkList;

   } catch(e){
   print(e.toString());

    }
  }

  Future setRating(String parkname,var uid,double rating) async{
    try{
      await _remote.setRating(parkname, uid, rating);


    } catch(e){
      print(e.toString());

    }
  }

  Future<double> getRating(String parkname) async{
    try{
      var d= await _remote.getRating(parkname);
      print(d);
      return d;

    } catch(e){
      print(e.toString());

    }
  }

  Future<double> getUserRating(String parkname,var uid) async{
    try{
      var d= await _remote.getuUserRating(parkname,uid);
      print(d);
      return d;

    } catch(e){
      print(e.toString());

    }
  }

  @override
  Future setActiviy(idenfitier,state) async{
    await _remote.setActiviy(idenfitier, state);
  }




}