import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solution_challenge/domain/models/parks.dart';
import 'package:solution_challenge/domain/models/tasks.dart';

class Remote{
  Query query =
  FirebaseFirestore.instance.collection('parklist');


///parklist
  Future<List<Parks>> getParkList()async{

    List<Parks> parkList=List<Parks>();
    await query.get().then((querySnapshot) async {
      print(querySnapshot.size.toString()+'  gelen park sayısı');

      querySnapshot.docs.forEach((document) {

        Map<String,dynamic> t=document.data();
        parkList.add(Parks.fromJsonMap(t));

      });
});
    return parkList;

}

  ///photos
  Future<List<Tasks>> getTaskPhoto()async{
    List<Tasks> d=[];
    Query query =
    FirebaseFirestore.instance.collection('gorevler');
    List<String> photoList=[];

     await query.get().then((querySnapshot) async {

      querySnapshot.docs.forEach((document)async {

        Map<String,dynamic> t= document.data();
       d.add( Tasks.fromJsonMap(t));

      });
    });

     return d;

  }

  Future<bool> getTaskState({taskName, uid})async{
          DocumentReference query2 = FirebaseFirestore.instance.collection('gorevler').doc(taskName).collection('users').doc(uid);
          bool t;
          
    await query2.get().then((querySnapshot) async {
      querySnapshot.data()!=null?
      querySnapshot.data().forEach((key, value) {
        t=value;
        print('task'+t.toString());

      }):t=false;


    });

    return t;

  }



  ///ratings
  Future setRating(String parkname,var uid,double rating) async{

  DocumentReference query2 =  FirebaseFirestore.instance.collection('stars').doc(parkname).collection('users').doc(uid);

   await query2.set({
    'value': rating
  });
}

  Future setNote(var rating) async{

    DocumentReference query2 =  FirebaseFirestore.instance.collection('note').doc(rating);

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

  Future setTaskState({uid, bool state, taskName})async{
    DocumentReference query2 = FirebaseFirestore.instance.collection('gorevler').doc(taskName).collection('users').doc(uid);

    query2.set({
      'complete':true
    });

  }

  Future setLevel({uid,level})async{
    DocumentReference query2 = FirebaseFirestore.instance.collection('USERSLEVEL').doc(uid);
    int levelNew= level+1;
    query2.set({
      'level':levelNew
    });

  }

  Future<int> getLevel({uid,level})async{
    int level;
    DocumentReference query2 =  FirebaseFirestore.instance.collection('USERSLEVEL').doc(uid);
     await query2.get().then((value) {
     Map d=  value.data();
     if(d!=null)
     level=d['level'];

     });

    print('levels: '+level.toString());

    return  level;
  }

  @override
  Future setActiviy(idenfitier,state)async {
    if(state =="ENTER"){
    await  FirebaseFirestore.instance.collection('parklist').doc(idenfitier).update(
          {
            "TotalActivity":FieldValue.increment(1),
            "InstantActivity":FieldValue.increment(1)


          });
    }if(state=="EXIT"){

     await FirebaseFirestore.instance.collection('parklist').doc(idenfitier).update(
          {
            "InstantActivity":FieldValue.increment(-1)


          });
    }
  }


}