import 'package:solution_challenge/domain/models/parks.dart';
import 'package:solution_challenge/domain/repository/remote_source.dart';

abstract class ProductRepositoryAbs{
Future getParkList();
}

class ProductRepository implements ProductRepositoryAbs{
  Remote _remote=Remote();

  @override
  Future<List<Parks>> getParkList() async{
   try{
  List<Parks> parkList=await _remote.getParkList();

  return parkList;

   } catch(e){
   print(e.toString());

    }
  }



}