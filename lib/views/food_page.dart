import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/colors.dart';
import 'package:food_delivery/cubit/basketPageCubit.dart';
import 'package:food_delivery/entity/yemekler.dart';
import 'package:food_delivery/repository/user_repository.dart';
import 'package:food_delivery/views/basket_page.dart';
import 'package:food_delivery/views/home_page.dart';

class FoodPage extends StatefulWidget {
  Yemekler yemek;

  FoodPage({required this.yemek});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  var userRepo = UserRepository();
  late int amount = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // context.read<BasketPageCubit>().getSepet(value.userName);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var yemek = widget.yemek;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.yemek.yemek_adi,
              style: TextStyle(fontFamily: "JosefinNormal", fontSize: 26)),
          backgroundColor: c5,
        ),
        body: Center(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: c1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    height: MediaQuery.of(context).size.height / 1.2,
                    decoration: BoxDecoration(
                        border: Border.all(color: c5, width: 2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.network(
                            "http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemek_resmi_adi}"),
                        Text(
                          yemek.yemek_adi,
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: "JosefinItalic"),
                        ),
                        Text(
                          "${int.parse(yemek.yemek_fiyat) * amount} ₺",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "JosefinNormal"),
                        ),
                        amountButtonBuilder(size),
                        addToSepetButtonBuilder(size, "Sepete Ekle")
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }

  Widget amountButtonBuilder(Size size) {
    return Container(
      width: size.width / 3.2,
      height: size.height / 20,
      decoration: BoxDecoration(
          border: Border.all(color: c2, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
                onPressed: () {
                  setState(() {
                    amount != 1 ? amount -= 1 : amount;
                  });
                },
                icon: const Icon(
                  Icons.remove,
                  color: Colors.red,
                  size: 20,
                )),
            Text(
              amount.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "JosefinNormal"),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    amount += 1;
                  });
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.green,
                  size: 20,
                ))
          ],
        ),
      ),
    );
  }

  Widget addToSepetButtonBuilder(Size size, String buttonName) {
    return Padding(
        padding: EdgeInsets.only(top: size.height / 30),
        child: SizedBox(
          width: size.width / 1.6,
          height: size.height / 20,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(buttonName),
            onPressed: () {
              sepeteEkle();
            },
            style: ElevatedButton.styleFrom(
                primary: c5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
        ));
  }

  void sepeteEkle() {
    print("Sepete Ekle");

    userRepo.getUserId().then((userId) {
      userRepo.getUser(userId).then((user) {
        print(user!.email);
        print(user.userName);

        print(widget.yemek.yemek_adi);
        print(widget.yemek.yemek_fiyat);


        
        context
            .read<BasketPageCubit>()
            .addToSepet(widget.yemek, user.userName, amount)
            .onError((error, stackTrace){
                context
                .read<BasketPageCubit>()
                .addToSepetWithoutCheck(widget.yemek, user.userName, amount)
                .then((_) {

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return HomePage(
                          firstTimeLogin: false,
                          choosenIndex: 1,
                        );
                      }));
        });

            })
            .then((_) {

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return HomePage(
                      firstTimeLogin: false,
                      choosenIndex: 1,
                    );
                  }));
        });

        
        
      });
    });
  }
}
