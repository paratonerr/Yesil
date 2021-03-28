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


Future setRating(String parkname,var uid,double rating) async{

  DocumentReference query2 =  FirebaseFirestore.instance.collection('stars').doc(parkname).collection('users').doc(uid);

   await query2.set({
    'value': rating
  });


}

Future<double> getRating(String parkname)async {
    double rating=0;
   int ratingCount;
    double ortrating=0;

  CollectionReference ratingList =  FirebaseFirestore.instance.collection('stars').doc(parkname).collection('users');
  await ratingList.get().then((value) {
     ratingCount=value.docs.length;
     value.docs.forEach((element) {

       Map map=element.data();
       rating=rating + map["value"];
     });
      ortrating= rating/ratingCount;
     print(ortrating.toString() +"remote");
   });

    return  ortrating;


}

  Future<double> getuUserRating(String parkname,var uid)async {
    double rating=0;

    DocumentReference ratingList =  FirebaseFirestore.instance.collection('stars').doc(parkname).collection('users').doc(uid);
    await ratingList.get().then((value) {
      Map d=value.data();
      rating=d['value'];
      print(value.data().toString()+"user rating");
    });

    return  rating;


  }


}