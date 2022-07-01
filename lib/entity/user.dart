import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserEntity {
  String email;
  String userName;
  String name;
  DateTime timeStamp;

  UserEntity(
      {required this.email,
      required this.userName,
      required this.name,
      required this.timeStamp});

  Map<String, dynamic> toJson() => {
        'email': email,
        'userName': userName,
        'name': name,
        'timeStamp': timeStamp
      };

  static UserEntity fromJson(Map<String, dynamic> json) => UserEntity(
      email: json['email'],
      userName: json['userName'],
      name: json['name'],
      timeStamp: new DateTime.now());


     factory UserEntity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserEntity(
      email: data?["email"],
      userName: data?["userName"],
      name: data?["name"],
      timeStamp: data?["timeStamp"]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (email != null) "email": email,
      if (userName != null) "userName": userName,
      if (name != null) "name": name,
      if (timeStamp != null) "timeStamp": timeStamp,
    };
  }
  

  // A simple Future which will return the fetched Product in form of Object.
  
 


}
