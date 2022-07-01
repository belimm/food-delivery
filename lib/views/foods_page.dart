import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/colors.dart';
import 'package:food_delivery/cubit/homePageCubit.dart';
import 'package:food_delivery/entity/yemekler.dart';
import 'package:food_delivery/views/food_page.dart';

class FoodsPage extends StatefulWidget {
  FoodsPage({Key? key}) : super(key: key);

  @override
  State<FoodsPage> createState() => _FoodsPageState();
}

class _FoodsPageState extends State<FoodsPage> with TickerProviderStateMixin {
  late AnimationController animasyonKontrol =
      AnimationController(vsync: this, duration: Duration(milliseconds: 0));
  late Animation<double> alphaAnimasyonDegerleri;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<FoodPageCubit>().getYemekler();
    


    alphaAnimasyonDegerleri =
        Tween(begin: 1.0, end: 1.0).animate(animasyonKontrol)
          ..addListener(() {
            setState(() {});
          });


    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animasyonKontrol.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodPageCubit, List<Yemekler>>(
      builder: (context, yemeklerListesi) {
        if (yemeklerListesi.isNotEmpty) {
          return GridView.builder(
            itemCount: yemeklerListesi.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 2 / 2.5),
            itemBuilder: (context, index) {
              var yemek = yemeklerListesi[index];
              // yemek.yemek_resmi_adi=="kofte.png" ?yemek.yemek_resmi_adi="izgarakofte.png":yemek.yemek_resmi_adi;

              print(yemeklerListesi.length);

              return GestureDetector(
                onTap: () {
                  animasyonKontrol.forward();
                  
                  print("Yemek ${yemek.yemek_adi} seçildi");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FoodPage(yemek: yemek)),
                  );
                },
                child: Opacity(
                  opacity: alphaAnimasyonDegerleri.value,
                  child: Card(
                    elevation: 3,
                    color: c1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side:  BorderSide(color: c2, width: 0.75),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 170,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                  "http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemek_resmi_adi}"),
                            ),
                          ),
                        ),
                        
                        Text("${yemek.yemek_adi}",style: TextStyle(fontWeight: FontWeight.bold),),

                        Container(
                          width: MediaQuery.of(context).size.width/5,
                          height: MediaQuery.of(context).size.height/20,
                          
                          decoration: BoxDecoration(
		                        color: c2,
		                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          child: Center(
                            child: Text(
                              "${yemek.yemek_fiyat} ₺",
                              style: TextStyle(fontSize: 20,color: c5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center();
        }
      },
    );
  }
}
