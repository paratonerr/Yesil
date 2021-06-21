import 'package:google_maps_flutter/google_maps_flutter.dart';

class Tasks{
 String taskName;
 String photo;
 String task;
 String task2;
 String content1;
 String content1photo;
 String content2;
 String content2photo;
 String content3;
 String content3photo;
 bool state=false;

 Tasks({this.photo,this.taskName});


 Tasks.fromJsonMap(Map<String, dynamic> map):
        taskName=map['taskName'],
        content1=map['content1'],
        content1photo=map['content1photo'],
        content2=map['content2'],
        content2photo=map['content2photo'],
        content3=map['content3'],
        content3photo=map['content3photo'],
        task=map['task'],
        task2=map['task2'],
        photo=map['photo'];

}





