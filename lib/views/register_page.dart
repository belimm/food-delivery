import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/colors.dart';
import 'package:food_delivery/entity/user.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/views/login_page.dart';
import 'package:food_delivery/views/welcome_page.dart';
import 'package:food_delivery/entity/user.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var tfControllerName = TextEditingController();
  var tfControllerUserName = TextEditingController();
  var tfControllerEmail = TextEditingController();
  var tfControllerPassword = TextEditingController();
  var tfControllerPasswordAgain = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Register");
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height / 30,
                      left: size.width / 20,
                      right: size.width / 20),
                  child: TextField(
                    controller: tfControllerName,
                    decoration: InputDecoration(
                      hintText: "İsim",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.person,
                        color: c5,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: c4, width: 1),
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
                    controller: tfControllerUserName,
                    decoration: InputDecoration(
                      hintText: "Hesap İsmi",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.abc,
                        color: c5,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
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
                  child: TextFormField(
                    controller: tfControllerEmail,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) {},
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.email, color: c5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
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
                    obscureText: true,
                    controller: tfControllerPassword,
                    decoration: InputDecoration(
                      hintText: "Şifre",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.key,
                        color: c5,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
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
                    obscureText: true,
                    controller: tfControllerPasswordAgain,
                    decoration: InputDecoration(
                      hintText: "Şifre",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.key,
                        color: c5,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.yellow, width: 10),
                      ),
                    ),
                  ),
                ),
                Button(size, "Register"),
                SizedBox(
                  height: size.height / 30,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      "Giriş",
                      style: TextStyle(color: c5),
                    ))
              ],
            ),
          ),
        ));
  }

  Widget Button(Size size, String buttonName) {
    return Padding(
        padding: EdgeInsets.only(top: size.height / 30),
        child: SizedBox(
          width: size.width / 1.4,
          height: size.height / 20,
          child: ElevatedButton.icon(
            icon: Icon(Icons.person_add),
            label: Text("Kaydol"),
            onPressed: () {
              if (tfControllerEmail.text.isEmpty ||
                  tfControllerPassword.text.isEmpty) {
                _showDialogForEmptyFields();
              } else if (tfControllerPassword.text !=
                  tfControllerPasswordAgain.text) {
                _showDialogForPasswordMismatch();
              } else if (tfControllerPassword.text.length < 6) {
                _showDialogForPasswordLength();
              } else {
                if (!emailValid(tfControllerEmail.text)) {
                  _showDialogForInvalidEmail();
                } else {
                  signUp();
                }
              }
            },
            style: ElevatedButton.styleFrom(
                primary: c5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
        ));
  }

  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: tfControllerEmail.text.trim(),
          password: tfControllerPassword.text.trim());

      try {
        createUser();
      } catch (e1) {}

      _showDialogForSuccess();

      Navigator.pushReplacement(
          context,
          (MaterialPageRoute(
              builder: (context) => WelcomePage(
                    firstTimeLogin: true,
                  ))));
    } on FirebaseAuthException catch (e) {
      print(e.message);

      if (e.code == "email-already-in-use") {
        _showDialogForExistAccount();
      } else {
        _showDialogForWrongDetails();
      }
    } finally {}
  }

  void _showDialogForEmptyFields() {
    // ignore: avoid_single_cascade_in_expression_statements
    AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        title: "Uyarı",
        desc: "Lütfen tüm alanları doldurunuz",
        btnOkOnPress: () {})
      ..show();
  }

  Future createUser() async {
    print("createUserStart");
    FirebaseAuth auth = FirebaseAuth.instance;
    var uidOfUser = auth.currentUser?.uid;
    print("UIDOFUSER ${uidOfUser}");

    print("createUserFinish");
    final document =
        FirebaseFirestore.instance.collection("users").doc(uidOfUser);

    final json = {
      'email': tfControllerEmail.text,
      'name': tfControllerName.text,
      'userName': tfControllerUserName.text,
      'timestamp': DateTime.now(),
    };

    print("Json $json");

    print("Json ENd");

    var user = UserEntity(
        email: tfControllerEmail.text,
        userName: tfControllerUserName.text,
        name: tfControllerName.text,
        timeStamp: DateTime.now());

    var jsonn = user.toJson();
    print("JSONNN ${jsonn}");

    await document.set(jsonn);
  }

  void _showDialogForInvalidEmail() {
    // ignore: avoid_single_cascade_in_expression_statements
    AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        title: "Uyarı",
        desc: "Lütfen geçerli bir mail adresi giriniz!",
        btnOkOnPress: () {})
      ..show();
  }

  void _showDialogForExistAccount() {
    // ignore: avoid_single_cascade_in_expression_statements
    AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        title: "Uyarı",
        desc: "Girmiş olduğunuz mail adresine ait hesap mevcut!",
        btnOkOnPress: () {
          navigatorKey.currentState!.pop(context);
        })
      ..show();
  }

  void _showDialogForWrongDetails() {
    // ignore: avoid_single_cascade_in_expression_statements
    AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        title: "Uyarı",
        desc: "Yanlış kullanıcı bilgileri!",
        btnOkOnPress: () {})
      ..show();
  }

  void _showDialogForSuccess() {
    // ignore: avoid_single_cascade_in_expression_statements
    AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        title: "Başarılı",
        desc: "Hesabınız başarılı bir şekilde oluşturuldu!",
        btnOkOnPress: () {
          navigatorKey.currentState!.pop(context);
        })
      ..show();
  }

  void _showDialogForPasswordMismatch() {
    // ignore: avoid_single_cascade_in_expression_statements
    AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        title: "Hata",
        desc: "Şifreler uyuşmuyor!",
        btnOkOnPress: () {})
      ..show();
  }

  void _showDialogForPasswordLength() {
    // ignore: avoid_single_cascade_in_expression_statements
    AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        title: "Hata",
        desc: "Şifre en az 6 karakter uzunluğunda olmalıdır!",
        btnOkOnPress: () {})
      ..show();
  }

  bool emailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
