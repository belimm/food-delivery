import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../entity/user.dart';

class UserRepository {
  

  Future<UserEntity?> getUser(String id) async {
    var db = FirebaseFirestore.instance;
//
    final ref = await db.collection("users").doc(id).get();
    final user = ref.data();
    final userMapped = UserEntity.fromJson(user!);


    return userMapped;
  }

  Future<String> getUserId() async{
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<String> getUserName() async{
    var userAuth = FirebaseAuth.instance.currentUser!.uid;
    var db = FirebaseFirestore.instance;
//
    final ref = await db.collection("users").doc(userAuth).get();
    final user = ref.data();
    final userMapped = UserEntity.fromJson(user!);


    return userMapped.userName;
  }
  
  // 
  // static Future<UserEntity> getUser(String id) async {
  //   print("GetUser Method");
  //   var db = FirebaseFirestore.instance;
  //   final ref = db.collection("users").doc(id).withConverter(
  //         fromFirestore: UserEntity.fromFirestore,
  //         toFirestore: (UserEntity user, _) => user.toFirestore(),
  //       );

  //   final docSnap = await ref.get();
  //   final user = docSnap.data(); // Convert to City object
  //   if (user != null) {
  //     print("getUser $user");
  //     var userEntity = user;
  //     return user;
  //   } 
  //   else {
  //     print("No such document.");
  //   }

  //   print("Usersrerererer ${user.toString()}"); 

  //   return UserEntity(
  //       email: "berk.limoncu@gmail.com",
  //       userName: "berk_lim",
  //       name: "berk limoncu",
  //       timeStamp: DateTime.now());
  // }
}
