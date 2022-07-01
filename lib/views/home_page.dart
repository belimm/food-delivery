import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/colors.dart';
import 'package:food_delivery/cubit/basketPageCubit.dart';
import 'package:food_delivery/cubit/homePageCubit.dart';
import 'package:food_delivery/entity/user.dart';
import 'package:food_delivery/entity/yemekler.dart';

import 'package:food_delivery/repository/sepetdao_repository.dart';
import 'package:food_delivery/repository/user_repository.dart';
import 'package:food_delivery/repository/yemeklerdao_repository.dart';
import 'package:food_delivery/views/addto_cart_page.dart';
import 'package:food_delivery/views/basket_page.dart';
import 'package:food_delivery/views/foods_page.dart';
import 'package:food_delivery/views/welcome_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  bool firstTimeLogin;
  int choosenIndex;
  final TextEditingController controller = TextEditingController();
  HomePage({required this.firstTimeLogin, required this.choosenIndex});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool searchActive = false;
  bool totalUpdated = true;
  var yemekRep = YemeklerDaoRepository();
  var sepetRep = SepetDaoRepository();
  int choosenIndex = 0;
  var userEntity = UserEntity(
      email: "", userName: "userName", name: "name", timeStamp: DateTime.now());

  var userRepo = UserRepository();

  callbackFunction(String x) {
    print("callback");

    setState(() {
      totalUpdated = false;

      totalUpdated = true;
    });
  }

  @override
  void initState() {
    super.initState();

    choosenIndex = widget.choosenIndex;
  }

  @override
  void dispose() {
    print("signout");
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pageList = [
      FoodsPage(),
      BasketPage(
        callbackFunction: callbackFunction,
      )
    ];

    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      resizeToAvoidBottomInset: false ,
      floatingActionButton: choosenIndex == 1
          ? totalUpdated
              ? FloatingActionButton.extended(
                  backgroundColor: c5,
                  label: TotalAmount(),
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => AddCartPage())));
                  },
                )
              : null
          : null,
      appBar: AppBar(
        actions: [
          choosenIndex == 0
              ? searchActive
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          searchActive = false;
                        });
                      },
                      icon: const Icon(Icons.clear))
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          searchActive = true;
                        });
                      },
                      icon: const Icon(Icons.search))
              : IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WelcomePage(
                                firstTimeLogin: false,
                              )),
                    );
                    print("signout");
                  },
                )
        ],
        title: choosenIndex == 0
            ? searchActive
                ? TextField(
                    decoration: const InputDecoration(hintText: "Ara"),
                    controller: widget.controller,
                    onChanged: (aramaSonucu) {
                      print("Arama sonucu : $aramaSonucu");

                      // context.read<HomePageCubit>().searchTask(aramaSonucu);

                      context
                          .read<FoodPageCubit>()
                          .getYemeklerWithKeyword(aramaSonucu);
                    },
                  )
                : const Text("Food Me",
                    style: TextStyle(fontFamily: "JosefinNormal", fontSize: 26))
            : choosenIndex == 1
                ? const Text("Sepet",
                    style: TextStyle(fontFamily: "JosefinNormal", fontSize: 26))
                : const Text("Sepet Toplam",
                    style:
                        TextStyle(fontFamily: "JosefinNormal", fontSize: 26)),
        backgroundColor: c5,
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: choosenIndex == 0
              ? Stack(children: <Widget>[
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Carousel(),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          decoration: BoxDecoration(
                            color: c1,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0))),
                          height: MediaQuery.of(context).size.height/1.85,
                          
                          child: FoodsPage()))
                ])
              : BasketPage(callbackFunction: callbackFunction)),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: c5,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: "Yemekler"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Sepet"),
        ],
        currentIndex: choosenIndex,
        onTap: (index) {
          setState(() {
            choosenIndex = index;
          });
        },
      ),
    );
  }

  String getUserName() {
    userRepo.getUserId().then((userId) {
      userRepo.getUser(userId).then((user) {
        userEntity = user!;
        // print(user.name);
        return userEntity.name;
      });
    });

    return userEntity.name;
  }

  void firstTimeLogin() async {
    // ignore: avoid_single_cascade_in_expression_statements
    AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        title: "Başarılı",
        desc: "Hesabınız başarıyla oluşturuldu!",
        btnOkOnPress: () {})
      ..show();
  }
}

class TotalAmount extends StatefulWidget {
  TotalAmount();

  @override
  State<TotalAmount> createState() => _TotalAmountState();
}

class _TotalAmountState extends State<TotalAmount> {
  var sepetRepo = SepetDaoRepository();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: sepetRepo.getTotalAmount(),
      builder: (context, snapshott) {
        if (snapshott.hasData) {
          String? x = snapshott.data;
          print("xXxX $x");

          return Text.rich(TextSpan(
              text: "Toplam:\n",
              style: TextStyle(color: Colors.grey),
              children: [
                TextSpan(
                    text: "$x,00 ₺",
                    style: TextStyle(fontSize: 16, color: Colors.white))
              ]));
        } else if (snapshott.connectionState == ConnectionState.waiting) {
          return Center(child: const CircularProgressIndicator());
        } else {
          return const Text.rich(TextSpan(
              text: "Toplam:\n",
              style: TextStyle(color: Colors.grey),
              children: [
                TextSpan(
                    text: "0,00 ₺",
                    style: TextStyle(fontSize: 16, color: Colors.white))
              ]));
        }
      },
    );
  }
}

class Carousel extends StatelessWidget {
  const Carousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height/4.5,
            aspectRatio: 16/9,
            viewportFraction: 0.8,
            autoPlay: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInCirc,
            enlargeCenterPage: true
          ),
          items: [
            Container(
              color: Colors.red,
            ),
            Container(color: Colors.blue)
          ],  

        )
      ],
    );
  }
}

