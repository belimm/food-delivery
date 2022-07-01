import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/colors.dart';
import 'package:food_delivery/views/login_page.dart';
import 'package:food_delivery/views/register_page.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var tfControllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                Button(size, "Login"),
                SizedBox(
                  height: size.height / 30,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                    },
                    child: Text(
                      "Register Instead",
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
            icon: Icon(Icons.mail),
            label: Text("Reset Password"),
            onPressed: () {
              if (tfControllerEmail.text.isEmpty) {
                _showDialogForEmptyFields();
              } else if (emailValid(tfControllerEmail.text)) {
                _showDialogForInvalidEmail();
              } else {
                forgotPassword();
              }
            },
            style: ElevatedButton.styleFrom(
                primary: c5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
        ));
  }

  Future forgotPassword() async {
    print("Forgot Password");

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: tfControllerEmail.text.trim());

      _showDialogForEmailSent();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
    } catch (e) {
      _showDialogForThereIsNoUserWithThisEmail();
    }
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

  void _showDialogForEmailSent() {
    // ignore: avoid_single_cascade_in_expression_statements
    AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        title: "Başarılı",
        desc: "Şifreniz ${tfControllerEmail.text} adresine gönderildi",
        btnOkOnPress: () {})
      ..show();
  }

  void _showDialogForThereIsNoUserWithThisEmail() {
    // ignore: avoid_single_cascade_in_expression_statements
    AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        title: "Uyarı",
        desc: "Bu mail ${tfControllerEmail.text} adresine ait hesap bulunamadı!",
        btnOkOnPress: () {})
      ..show();
  }

  bool emailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
