import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/colors.dart';
import 'package:food_delivery/cubit/basketPageCubit.dart';
import 'package:food_delivery/cubit/homePageCubit.dart';
import 'package:food_delivery/entity/sepetler.dart';
import 'package:food_delivery/entity/yemekler.dart';
import 'package:food_delivery/repository/sepetdao_repository.dart';
import 'package:food_delivery/repository/user_repository.dart';
import 'package:food_delivery/views/food_page.dart';
import 'package:food_delivery/views/home_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../entity/user.dart';

class BasketPage extends StatefulWidget {
  final Function(String) callbackFunction;

  BasketPage({Key? key, required this.callbackFunction}) : super(key: key);

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  var currentUserId;
  var userRepo = UserRepository();
  var basketRepo = SepetDaoRepository();
  int totalPrice = 0;

  late UserEntity userEntity;

  @override
  void initState() {
    super.initState();

    userRepo.getUserId().then((userId) {
      currentUserId = userId;

      userRepo.getUser(currentUserId).then((user) {
        userEntity = user!;
        basketRepo.getTotalAmount().then((total) {
          totalPrice = int.parse(total);
        });

        context.read<BasketPageCubit>().getSepet(userEntity.userName);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasketPageCubit, List<Sepetler>>(
      builder: (context, sepetListesi) {
        if (sepetListesi.isNotEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 1.45,
            child: ListView.builder(
              itemCount: sepetListesi.length,
              itemBuilder: (context, index) {
                var yemek = sepetListesi[index];

                return Slidable(
                    key: UniqueKey(),
                    startActionPane: ActionPane(
                      dismissible: DismissiblePane(
                        onDismissed: () {
                          deleteYemek(yemek);
                          widget.callbackFunction("0");
                        },
                      ),
                      motion: DrawerMotion(),
                      children: [
                        SlidableAction(
                          backgroundColor: c5,
                          icon: Icons.delete,
                          onPressed: (context) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Delete ${yemek.yemek_adi}")));
                          },
                        )
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          backgroundColor: c5,
                          icon: Icons.remove,
                          onPressed: (context) {
                            decreaseAmount(yemek);
                            widget.callbackFunction("1");
                          },
                        ),
                        SlidableAction(
                          backgroundColor: Colors.green,
                          icon: Icons.add,
                          onPressed: (context) {
                            increaseAmount(yemek);
                          },
                        )
                      ],
                    ),
                    child: buildListTile(yemek));
              },
            ),
          );
        } 
        
        else {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.height / 10,
              decoration: BoxDecoration(
                  color: c2,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
              child: Center(
                child: Text(
                  "Boş Sepet",
                  style: TextStyle(fontSize: 20, color: c5),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildListTile(var yemek) {
    return GestureDetector(
      onTap: () {
        var ye = Yemekler(
            yemek_id: "",
            yemek_adi: yemek.yemek_adi,
            yemek_resmi_adi: yemek.yemek_resim_adi,
            yemek_fiyat: yemek.yemek_fiyat);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FoodPage(yemek: ye)),
        );
      },
      child: Card(
        elevation: 10,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(
              "http://kasimadalan.pe.hu/yemekresimler/${yemek.yemek_resim_adi}",
            ),
          ),
          title: Text(
            yemek.yemek_adi,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("${yemek.yemek_fiyat} ₺"),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 5,
                height: MediaQuery.of(context).size.height / 20,
                decoration: BoxDecoration(
                    color: c2,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(10.0))),
                child: Center(
                  child: Text(
                    "${calculatePrice(yemek)} ₺",
                    style: TextStyle(fontSize: 20, color: c5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTotalAmount(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Text(
              "Total",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Total",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  void decreaseAmount(var yemek) {
    var y = Yemekler(
        yemek_id: "",
        yemek_adi: yemek.yemek_adi,
        yemek_resmi_adi: yemek.yemek_resim_adi,
        yemek_fiyat: yemek.yemek_fiyat);

    if (int.parse(yemek.yemek_siparis_adet) > 1) {
      context
          .read<BasketPageCubit>()
          .deleteFromSepet(int.parse(yemek.sepet_yemek_id), userEntity.userName)
          .then((_) {
        context
            .read<BasketPageCubit>()
            .addToSepetWithoutCheck(
                y, userEntity.userName, int.parse(yemek.yemek_siparis_adet) - 1)
            .then((_) {
          context
              .read<BasketPageCubit>()
              .getSepet(userEntity.userName)
              .then((_) {
            widget.callbackFunction("3");
          });
        });
      });
    } else {
      deleteYemek(yemek);
    }
  }

  void increaseAmount(var yemek) {
    print("Add");

    var y = Yemekler(
        yemek_id: "",
        yemek_adi: yemek.yemek_adi,
        yemek_resmi_adi: yemek.yemek_resim_adi,
        yemek_fiyat: yemek.yemek_fiyat);

    context
        .read<BasketPageCubit>()
        .deleteFromSepet(int.parse(yemek.sepet_yemek_id), userEntity.userName)
        .then((_) {
      context
          .read<BasketPageCubit>()
          .addToSepetWithoutCheck(
              y, userEntity.userName, int.parse(yemek.yemek_siparis_adet) + 1)
          .then((_) {
        context.read<BasketPageCubit>().getSepet(userEntity.userName).then((_) {
          widget.callbackFunction("2");
        });
      });
    });
  }

  void deleteYemek(var yemek) {
    context
        .read<BasketPageCubit>()
        .deleteFromSepet(int.parse(yemek.sepet_yemek_id), userEntity.userName)
        .then((_) {
      context.read<BasketPageCubit>().getSepet(userEntity.userName).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            "Yemek Silindi",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        );
        
      }).onError((error, stackTrace) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (builder) =>
                  HomePage(firstTimeLogin: false, choosenIndex: 0)),
          (route) => false));
    });
  }

  int calculatePrice(var sepetYemek) {
    return int.parse(sepetYemek.yemek_siparis_adet) *
        int.parse(sepetYemek.yemek_fiyat);
  }
}
