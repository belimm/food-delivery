import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/colors.dart';
import 'package:food_delivery/views/home_page.dart';
import 'package:food_delivery/views/login_page.dart';
import 'package:food_delivery/views/register_page.dart';

class WelcomePage extends StatefulWidget {
  bool firstTimeLogin;
  WelcomePage({required this.firstTimeLogin});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (snapshot.hasData) {
          print("HomePageeeee");

          return HomePage(
            firstTimeLogin: true,
            choosenIndex: 0,
          );
        } else {
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
                      Button(context, size, "Giriş Yap"),
                      Button(context, size, "Kaydol"),
                    ],
                  ),
                ),
              ));
        }
      },
    );
  }
}

Widget Button(BuildContext context, Size size, String buttonName) {
  return Padding(
    padding: EdgeInsets.only(top: size.height / 30),
    child: SizedBox(
        width: size.width / 1.4,
        height: size.height / 20,
        child: ElevatedButton.icon(
          icon: Icon(buttonName == 'Login' ? Icons.login : Icons.person_add),
          label: Text(buttonName),
          onPressed: () {
            if (buttonName == "Login") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
              print("Register");
            }
          },
          style: ElevatedButton.styleFrom(
              primary: c5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
        )),
  );
}
