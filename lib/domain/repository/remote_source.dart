import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solution_challenge/domain/models/parks.dart';

class Remote{
  Query query =
  FirebaseFirestore.instance.collection('parklist');

  Future<List<Parks>> getParkList()async{

    List<Parks> parkList=List<Parks>();

    await query.get().then((querySnapshot) async {

      querySnapshot.docs.forEach((document) {

        Map<String,dynamic> t=document.data();
        parkList.add(Parks.fromJsonMap(t));

      });
});
    return parkList;

}

}