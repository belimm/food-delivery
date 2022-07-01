// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/colors.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/views/forgotpassword_page.dart';
import 'package:food_delivery/views/home_page.dart';
import 'package:food_delivery/views/register_page.dart';
import 'package:food_delivery/views/welcome_page.dart';
import 'package:food_delivery/widgets/login_button.dart';
import 'package:food_delivery/entity/user.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var tfControllerEmail = TextEditingController();
  var tfControllerPassword = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print("Login Page: ${FirebaseAuth.instance.currentUser}");
    
  }

  @override
  void dispose() {
    tfControllerEmail.dispose();
    tfControllerPassword.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false ,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: Image.asset("assets/logo1.png").image,
                          fit: BoxFit.fill)),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height / 30,
                      left: size.width / 20,
                      right: size.width / 20),
                  child: TextField(
                    controller: tfControllerEmail,
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.email, color: c5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.yellow, width: 10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height / 30,
                      left: size.width / 20,
                      right: size.width / 20),
                  child: TextField(
                    controller: tfControllerPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Şifre",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.key,
                        color: c5,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.yellow, width: 10),
                      ),
                    ),
                  ),
                ),
                Button(size, "Giriş"),
                SizedBox(
                  height: size.height / 30,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()));
                    },
                    child: Text(
                      "Şifremi unuttum?",
                      style: TextStyle(color: c5),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                    },
                    child: Text(
                      "Kaydol",
                      style: TextStyle(color: c5),
                    ))
              ],
            ),
          ),
        ));
  }

  // Future signIn() async {
  //   await FirebaseAuth.instance
  //       .signInWithEmailAndPassword(
  //         email: email,
  //         password: password
  //   );
  // }
  Widget Button(Size size, String buttonName) {
    return Padding(
        padding: EdgeInsets.only(top: size.height / 30),
        child: SizedBox(
          width: size.width / 1.6,
          height: size.height / 20,
          child: ElevatedButton.icon(
            icon: Icon(Icons.login, color: Colors.white),
            label: Text(buttonName),
            onPressed: () {
              if (tfControllerEmail.text.isEmpty ||
                  tfControllerPassword.text.isEmpty) {
                _showDialogForEmptyFields();
              } else if (!emailValid(tfControllerEmail.text)) {
                print(tfControllerEmail.text);
                _showDialogForInvalidEmail();
              } else {
                signIn();
              }
            },
            style: ElevatedButton.styleFrom(
                primary: c5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
        ));
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: tfControllerEmail.text.trim(),
          password: tfControllerPassword.text.trim());

      FirebaseAuth auth = FirebaseAuth.instance;
      var uidOfUser = auth.currentUser?.uid;
      var emailOfUser = auth.currentUser?.email;

      // var user = getUser(uidOfUser!, emailOfUser!);

      //      print("ReadUserrrrrrr ${user}");
      //Future<UserEntity> user = getUser(uidOfUser.toString());

 //     print("Userrr ${user.toString()}");

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => WelcomePage(
                    firstTimeLogin: false,
                  )),
          (Route<dynamic> route) => false);
    } on FirebaseAuthException catch (e) {
      _showDialogForWrongPassword();
    }
  }

  

  Stream<UserEntity> readUser(String e) => FirebaseFirestore.instance
      .collection("users")
      .snapshots()
      .map((snapshot) => snapshot.docs
              .map((doc) => UserEntity.fromJson(doc.data()))
              .toList()
              .firstWhere((eachElement) => eachElement.email == e, orElse: () {
            return UserEntity(
                email: tfControllerEmail.text,
                userName: "",
                name: "",
                timeStamp: DateTime.now());
          }));

  void _showDialogForEmptyFields() {
    // ignore: avoid_single_cascade_in_expression_statements
    AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        title: "Uyarı",
        desc: "Lütfen tüm alanları doldurunuz!",
        btnOkOnPress: () {})
      ..show();
  }

  void _showDialogForWrongPassword() {
    // ignore: avoid_single_cascade_in_expression_statements
    AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        title: "Uyarı",
        desc: "Yanlış kullanıcı bilgileri!",
        btnOkOnPress: () {
          navigatorKey.currentState!.pop(context);
        })
      ..show();
  }

  void _showDialogForInvalidEmail() {
    // ignore: avoid_single_cascade_in_expression_statements
    AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        title: "Uyarı",
        desc: "Lütfen geçerli bir mail adresi girin!",
        btnOkOnPress: () {})
      ..show();
  }

  bool emailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
