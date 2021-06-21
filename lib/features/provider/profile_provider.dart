import 'package:flutter/cupertino.dart';
import 'package:solution_challenge/domain/models/tasks.dart';
import 'package:solution_challenge/domain/repository/remote_source.dart';

class Profile_Provider with ChangeNotifier{
  Remote _remote =Remote();
  int _userlevel;
  bool taskState;
  bool _taskStateLoading=false;

  bool get taskStateLoading => _taskStateLoading;

  set taskStateLoading(bool value) {
    _taskStateLoading = value;
    notifyListeners();
  }

  int get userlevel => _userlevel;

  set userlevel(int value) {
    _userlevel = value;
    notifyListeners();
  }

  List<Tasks> photoList =[];

  Future getTaskPhoto({uid})async{
    photoList.clear();

  // ignore: missing_return
    await _remote.getTaskPhoto().then((value)async {

      value.forEach((element) {
        photoList.add(element);
      });

      List.generate(photoList.length, (index) async
      {
       photoList[index].state= await getTaskState(uid: uid,taskName:photoList[index].taskName);
       print( photoList[index].state);
       if(photoList.length-1==index){
         taskStateLoading=true;
       }
      });

    });
    print(taskStateLoading);

  notifyListeners();
  }

  Future setTaskState({uid, taskName})async{
   await _remote.setTaskState(uid: uid,taskName: taskName,state: true);

  }

   Future<bool> getTaskState({uid, taskName})async{
   bool t= await _remote.getTaskState(uid: uid,taskName: taskName);


   return t;
    }


  Future setLevel({uid,level})async{
  await  _remote.setLevel(uid: uid,level: level);

  }

  Future getLevel({uid,level})async{
    await  _remote.getLevel(uid: uid,level: level).then((value) {
      // ignore: unnecessary_statements
      userlevel=value;
      print('provider level: '+value.toString());

   });

   if(userlevel==null)userlevel=0;


   notifyListeners();

  }


}